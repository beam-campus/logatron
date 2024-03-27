defmodule LogatronEdge.Landscape.Channel do
  @moduledoc """
  LogatronEdge.Landscape.Channel is a GenServer that manages a channel to a landscape,
  """
  use GenServer, restart: :transient

  alias LogatronEdge.Client

  require Logger

  @attach_landscape_v1 "attach_landscape:v1"

  ############ API ##########
  def attach_landscape(landscape_init),
    do:
      GenServer.cast(
        via(landscape_init.id),
        {:attach_landscape, landscape_init}
      )

  ########### CALLBACKS ################
  @impl true
  def handle_cast({:attach_landscape, landscape_init}, _state) do
    Logger.debug(" :attach_landscape ~> #{landscape_init.id}")
    Client.publish(landscape_init.edge_id, @attach_landscape_v1, landscape_init)
    {:noreply, landscape_init}
  end


  @impl true
  def init(landscape_init) do
    {:ok, landscape_init}
  end

  ############### PLUMBING ##############
  def child_spec(landscape_init),
    do: %{
      id: via(landscape_init.id),
      start: {__MODULE__, :start_link, [landscape_init]},
      type: :worker
    }

  def to_name(key) when is_bitstring(key),
    do: "logatron_edge.landscape.channel.#{key}"

  def via(key),
    do: Logatron.Registry.via_tuple({:channel, to_name(key)})

  def start_link(landscape_init),
    do:
      GenServer.start_link(
        __MODULE__,
        landscape_init,
        name: via(landscape_init.id)
      )
end
