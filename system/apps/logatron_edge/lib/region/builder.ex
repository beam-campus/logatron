defmodule Logatron.Region.Builder do
  use GenServer

  @moduledoc """
  Logatron.Region.Builder is a GenServer that constructs an Logatron.Region
  by spawning Logatron.MngFarm Processes.
  """

  alias Logatron.MngFarm.InitParams, as: FarmInit

  require Logger

  ############# CALLBACKS ############
  @impl GenServer
  def init(region_init) do
    do_build(region_init)
    {:ok, region_init}
  end

  ############# INTERNALS ############
  defp do_build(region_init) do
    Enum.to_list(1..region_init.nbr_of_farms)
    |> Enum.map(& from_region(&1, region_init))
    |> Enum.each(fn farm_init -> Logatron.Region.Farms.start_farm(region_init.id, farm_init) end)
  end

  defp from_region(_, region_init),
    do: FarmInit.from_region(region_init)

  ################# PLUMBING ################
  def to_name(key),
    do: "region.builder.#{key}"

  def via(region_id),
    do: Logatron.Registry.via_tuple({:region_builder, to_name(region_id)})

  def child_spec(%{id: region_id} = region_init) do
    %{
      id: to_name(region_id),
      start: {__MODULE__, :start_link, [region_init]},
      restart: :temporary,
      type: :worker
    }
  end

  def start_link(%{id: region_id} = region_init),
    do:
      GenServer.start_link(
        __MODULE__,
        region_init,
        name: via(region_id)
      )
end
