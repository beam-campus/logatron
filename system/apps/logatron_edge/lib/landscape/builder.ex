defmodule LogatronEdge.Landscape.Builder do
  @moduledoc """
  LogatronEdge.Landscape.Worker is a GenServer that manages the state of a Landscape.
  """
  alias Countries.Cache
  use GenServer

  require Logger
  require Countries.Cache

  ########## API #######################
  def init_landscape(l) do
    Cache.countries_of_regions(l.select_from, l.min_area, l.min_people)
    |> Enum.take_random(l.nbr_of_countries)
    |> Enum.each(fn country ->
      region_id =
        country.name
        |> String.replace(" ", "_")
        |> String.downcase()

      region_init = Logatron.Region.InitParams.random(region_id)
      LogatronEdge.Landscape.Regions.start_region(l.id, region_init)
    end)

    Logger.debug(
      "\n\n\t#{Colors.red_on_black()}Landscape [#{l.id}] has been initialized #{Colors.reset()}\n\n"
    )
  end

  def get_state(landscape_id),
    do:
      GenServer.call(
        via(landscape_id),
        {:get_state}
      )

  ########## CALLBACKS ################
  @impl GenServer
  def init(landscape_init) do
    {:ok, landscape_init}
  end

  @impl GenServer
  def handle_call({:get_state}, _from, state) do
    {:reply, state, state}
  end


  ############## PLUMBING ############
  def to_name(key) when is_bitstring(key),
    do: "landscape.builder.#{key}"

  def via(key),
    do: Logatron.Registry.via_tuple({:builder, to_name(key)})

  def child_spec(%{id: landscape_id} = landscape_init),
    do: %{
      id: to_name(landscape_id),
      start: {__MODULE__, :start_link, [landscape_init]},
      type: :worker,
      restart: :transient
    }

  def start_link(%{id: landscape_id} = landscape_init),
    do:
      GenServer.start_link(
        __MODULE__,
        landscape_init,
        name: via(landscape_id)
      )
end
