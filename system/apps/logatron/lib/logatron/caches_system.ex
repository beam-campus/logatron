defmodule Logatron.CachesSystem do
  use GenServer

  @moduledoc """
  Logatron.MngFarms.System is a GenServer that manages the MngFarms cache system.
  """

  require Logger


  ################## CALLBACKS ############
  @impl GenServer
  def init(opts) do
    children = [
      Logatron.Edges.Server,
      Logatron.Scapes.Server,
      Logatron.Regions.Server,
      Logatron.MngFarms.Server,
      Logatron.Born2Dieds.Server
    ]

    Supervisor.start_link(
      children,
      strategy: :one_for_one,
      name: :caches_system_supervisor
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
