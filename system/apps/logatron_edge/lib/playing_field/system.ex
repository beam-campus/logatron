defmodule PlayingField.System do
  use GenServer

  @moduledoc """
  The System module is used to manage the PlayingField subsystem
  """

  require Logger

  ################### CALLBACKS ###################
  @impl GenServer
  def init(field_init) do
    Logger.debug("process: #{Colors.field_theme(self())}")

    Supervisor.start_link(
      [
        {PlayingField.Server, field_init}
      ],
      name: via_sup(field_init.id),
      strategy: :one_for_one
    )

    {:ok, field_init}
  end



  ###################### PLUMBING ######################
  defp to_name(field_id),
    do: "playing_field.sys.#{field_id}"

  def via(field_id),
    do: Logatron.Registry.via_tuple({:playing_field_sys, to_name(field_id)})

  def via_sup(field_id),
    do: Logatron.Registry.via_tuple({:playing_field_sup, to_name(field_id)})

  def start_link(field_init) do
    GenServer.start_link(
      __MODULE__,
      field_init,
      name: via(field_init.id)
    )
  end

  def child_spec(field_init) do
    %{
      id: to_name(field_init.id),
      start: {__MODULE__, :start_link, [field_init]},
      type: :supervisor,
      restart: :transient
    }
  end
end
