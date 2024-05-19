defmodule LogatronWeb.ViewFieldsLive.Index do
  use LogatronWeb, :live_view

  alias Phoenix.PubSub

  alias Edge.Facts, as: EdgeFacts
  alias Born2Died.Facts, as: LifeFacts
  alias MngFarm.Init, as: MngFarmInit

  alias Lives.Service, as: Lives
  alias Edges.Service, as: Edges
  alias Farms.Service, as: Farms
  alias Cells.Service, as: Cells

  require Logger

  def mount(params, _session, socket) do
    Logger.info("params: #{inspect(params)}")

    mng_farm_id = params["mng_farm_id"]

    case connected?(socket) do
      true ->
        PubSub.subscribe(Logatron.PubSub, LifeFacts.born2dieds_cache_updated_v1())
        PubSub.subscribe(Logatron.PubSub, EdgeFacts.edges_cache_updated_v1())

        farm = Farms.get(mng_farm_id)
        fields = Farms.build_fields(farm)
        cell_states = Cells.get_cell_states(mng_farm_id)

        {:ok,
         socket
         |> assign(
           lives: Lives.get_all(),
           edges: Edges.get_all(),
           mng_farm_id: mng_farm_id,
           farm: farm,
           fields: fields,
           cell_states: cell_states
         )}

      false ->
        {:ok,
         socket
         |> assign(
           edges: [],
           lives: [],
           mng_farm_id: mng_farm_id,
           farm: %MngFarmInit{},
           fields: [],
           cell_states: []
         )}
    end
  end
end
