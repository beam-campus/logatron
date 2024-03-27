defmodule Logatron.MngFarm.System do
  use GenServer

  @moduledoc """
  The Logatron.Farm.System supervises the Logatron.Farm.Channel and the Logatron.Farm.Herd.
  """

  require Logger

  ################### CALLBACKS ###################
  @impl GenServer
  def init(mng_farm_init) do
    children =
      [
        # {Logatron.MngFarm.Channel, mng_farm_init},
        {Logatron.MngFarm.Herd, mng_farm_init},
        {Logatron.MngFarm.HerdBuilder, mng_farm_init}
      ]

    Supervisor.start_link(
      children,
      name: via_sup(mng_farm_init.id),
      strategy: :one_for_one
    )

    {:ok, mng_farm_init}
  end


  ############ PLUMBING ############
  defp to_name(farm_id),
  do: "mng_farm.system.#{farm_id}"

  def via(farm_id),
    do: Logatron.Registry.via_tuple({:mng_farm_sys, to_name(farm_id)})

  def via_sup(farm_id),
    do: Logatron.Registry.via_tuple({:mng_farm_sup, to_name(farm_id)})

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
