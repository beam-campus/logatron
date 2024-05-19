defmodule LogatronWeb.ViewFieldsLive.Index do
  use LogatronWeb, :live_view

  alias Phoenix.PubSub

  alias Edge.Facts, as: EdgeFacts
  alias Born2Died.Facts, as: LifeFacts
  alias Field.Facts, as: FieldFacts
  alias MngFarm.Init, as: MngFarmInit

  alias Lives.Service, as: Lives
  alias Edges.Service, as: Edges
  alias Farms.Service, as: Farms
  alias Fields.Service, as: Fields

  require Logger

  @fields_cache_updated_v1 FieldFacts.fields_cache_updated_v1()

  def mount(params, _session, socket) do
    Logger.info("params: #{inspect(params)}")

    mng_farm_id = params["mng_farm_id"]

    case connected?(socket) do
      true ->
        PubSub.subscribe(Logatron.PubSub, LifeFacts.born2dieds_cache_updated_v1())
        PubSub.subscribe(Logatron.PubSub, EdgeFacts.edges_cache_updated_v1())
        PubSub.subscribe(Logatron.PubSub, FieldFacts.fields_cache_updated_v1())

        {:ok,
         socket
         |> assign(
           lives: Lives.get_all(),
           edges: Edges.get_all(),
           mng_farm_id: mng_farm_id,
           farm: Farms.get_by_mng_farm_id(mng_farm_id),
           fields: Fields.get_all_for_mng_farm_id(mng_farm_id)
         )}

      false ->
        {:ok,
         socket
         |> assign(
           edges: [],
           lives: [],
           mng_farm_id: mng_farm_id,
           fields: [],
           farm: %MngFarmInit{}
         )}
    end
  end

  def handle_info({@fields_cache_updated_v1, reason}, socket) do
    Logger.info("FieldLive.Index.handle_info: #{inspect(reason)}")
    mng_farm_id = socket.assigns.mng_farm_id

    {:noreply,
     socket
     |> assign(fields: Fields.get_all_for_mng_farm_id(mng_farm_id))}
  end
end
