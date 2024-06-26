defmodule Organization.System do
  use GenServer

  @moduledoc """
  The Logatron.Farm.System supervises the Logatron.Farm.RegionEmitter and the Logatron.Farm.Herd.
  """

  require Logger

  alias Region.Emitter, as: RegionEmitter
  alias Organization.Init, as: OrganizationInit

  ################### CALLBACKS ###################
  @impl GenServer
  def init(%OrganizationInit{} = mng_farm_init) do
    Process.flag(:trap_exit, true)

    Logger.debug("mng_farm.system: #{Colors.farm_theme(self())}")

    RegionEmitter.emit_initializing_farm(mng_farm_init)

    children =
      [
        # {Organization.Emitter, mng_farm_init},
        {Organization.Server, mng_farm_init},
        {Organization.Builder, mng_farm_init}
      ]

    Supervisor.start_link(
      children,
      name: via_sup(mng_farm_init.id),
      strategy: :one_for_one
    )

    RegionEmitter.emit_farm_initialized(mng_farm_init)

    {:ok, mng_farm_init}
  end

  @impl GenServer
  def terminate(_reason, mng_farm_init) do
    # Logger.info("Terminating Farm System #{to_name(mng_farm_init.id)}")
    RegionEmitter.emit_farm_detached(mng_farm_init)
    {:ok, mng_farm_init}
  end

  @impl GenServer
  def handle_info({:EXIT, _pid, _reason}, mng_farm_init) do
    # Logger.info("Received Farm System #{to_name(mng_farm_init.id)}")
    # RegionEmitter.emit_farm_detached(mng_farm_init)
    {:stop, :normal, mng_farm_init}
  end

  @impl GenServer
  def handle_info(msg, mng_farm_init) do
    Logger.warning("Unexpected message: #{inspect(msg)}")
    RegionEmitter.emit_farm_detached(mng_farm_init)
    {:noreply, mng_farm_init}
  end


  ############ PLUMBING ############
  defp to_name(farm_id),
  do: "mng_farm.system.#{farm_id}"

  def via(farm_id),
    do: Edge.Registry.via_tuple({:mng_farm_sys, to_name(farm_id)})

  def via_sup(farm_id),
    do: Edge.Registry.via_tuple({:mng_farm_sup, to_name(farm_id)})

  def child_spec(mng_farm_init) do
    %{
      id: to_name(mng_farm_init.id),
      start: {__MODULE__, :start_link, [mng_farm_init]},
      type: :supervisor,
      restart: :permanent,
      shutdown: 500
    }
  end

  def start_link(mng_farm_init),
    do:
      GenServer.start_link(
        __MODULE__,
        mng_farm_init,
        name: via(mng_farm_init.id)
      )
end
