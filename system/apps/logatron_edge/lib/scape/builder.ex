defmodule LogatronEdge.Scape.Builder do
  use GenServer
  @moduledoc """
  LogatronEdge.Scape.Worker is a GenServer that manages the state of a Scape.
  """
  require Logger
  require Countries.Cache

  alias Countries.Cache

  ########## API #######################
  def init_scape(scape_init) do
    selection =
      String.split(scape_init.select_from, ",")
      |> Enum.map(&String.trim/1)

    Cache.countries_of_regions(selection, scape_init.min_area, scape_init.min_people)
    |> Enum.take_random(scape_init.nbr_of_countries)
    |> Enum.each(fn country ->
      region_id =
        country.name
        |> String.replace(" ", "_")
        |> String.downcase()
      region_init = Logatron.Region.InitParams.random(scape_init.edge_id, scape_init.id, region_id, country.name)
      LogatronEdge.Scape.Regions.start_region(region_init)
    end)

    Logger.debug(
      "\n\n\t#{Colors.red_on_black()}Scape [#{scape_init.id}] has been initialized #{Colors.reset()}\n\n"
    )
  end

  def get_state(scape_id),
    do:
      GenServer.call(
        via(scape_id),
        {:get_state}
      )

  ########## CALLBACKS ################
  @impl GenServer
  def init(scape_init) do
    {:ok, scape_init}
  end

  @impl GenServer
  def handle_call({:get_state}, _from, state) do
    {:reply, state, state}
  end

  ############## PLUMBING ############
  def to_name(key) when is_bitstring(key),
    do: "scape.builder.#{key}"

  def via(key),
    do: Logatron.Registry.via_tuple({:builder, to_name(key)})

  def child_spec(%{id: scape_id} = scape_init),
    do: %{
      id: to_name(scape_id),
      start: {__MODULE__, :start_link, [scape_init]},
      type: :worker,
      restart: :transient
    }

  def start_link(%{id: scape_id} = scape_init),
    do:
      GenServer.start_link(
        __MODULE__,
        scape_init,
        name: via(scape_id)
      )
end
