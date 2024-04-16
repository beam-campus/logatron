defmodule Logatron.Regions.System do
  use GenServer

  @moduledoc """
  Logatron.Regions.System is a GenServer that manages the Regions cache system.
  """

  require Logger

  ################## CALLBACKS ############
  @impl GenServer
  def init(opts) do
    children = [
      Logatron.Regions.Server
    ]

    Supervisor.start_link(
      children,
      strategy: :one_for_one,
      name: :regions_system_supervisor
    )

    {:ok, opts}
  end

  ############### PLUMBING ################

  def child_spec(opts),
    do: %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      restart: :permanent
    }

  def start_link(opts),
    do:
      GenServer.start_link(
        __MODULE__,
        opts,
        name: __MODULE__
      )
end
