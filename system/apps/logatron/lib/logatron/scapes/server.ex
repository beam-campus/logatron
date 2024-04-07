defmodule Logatron.Scapes.Server do
  use GenServer

  @moduledoc """
  Logatron.Scapes.Server contains the GenServer for the Server.
  """
  alias Logatron.Scapes.Scape

  def update_scape_status(scape_id, status),
    do:
      GenServer.cast(
        via(scape_id),
        {:update_scape_status, status}
      )

  #################### CALLBACKS  ##################
  @impl true
  def handle_cast({:update_scape_status, status}, state),
    do: {:noreply, %{state | status: status}}

  @impl true
  def init(scape_init) do
    {:ok, Logatron.Scapes.Handover.get(scape_init.id)}
  end

  @impl true
  def terminate(reason, state) do
    Logatron.Scapes.Handover.save(state)
    {:ok, state}
  end

  ###################  PLUMBING  ###################

  def start_link(scape_init) do
    GenServer.start_link(
      __MODULE__,
      scape_init,
      name: via(scape_init.id)
    )
  end

  def to_name(key) when is_bitstring(key),
    do: "scape.server.#{key}"

  def via(key),
    do: Logatron.Registry.via_tuple({:scape_server, to_name(key)})

  def child_spec(scape_init) do
    %{
      id: via(scape_init.id),
      start: {__MODULE__, :start_link, [scape_init]},
      type: :worker
    }
  end
end
