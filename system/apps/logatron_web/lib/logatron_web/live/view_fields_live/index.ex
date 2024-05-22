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

  @lives_cache_updated_v1 LifeFacts.born2dieds_cache_updated_v1()
  @edges_cache_updated_v1 EdgeFacts.edges_cache_updated_v1()
  @life_moved_v1 LifeFacts.life_moved_v1()

  def mount(params, _session, socket) do
    Logger.info("params: #{inspect(params)}")

    mng_farm_id = params["mng_farm_id"]

    case connected?(socket) do
      true ->
        PubSub.subscribe(Logatron.PubSub, @lives_cache_updated_v1)
        PubSub.subscribe(Logatron.PubSub, @edges_cache_updated_v1)

        farm = Farms.get(mng_farm_id)

        fields = Farms.build_fields(farm)

        cell_states = Cells.get_cell_states(mng_farm_id)

        {:ok,
         socket
         |> assign(
           lives: Lives.get_by_mng_farm_id(mng_farm_id),
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


  def handle_info({@life_moved_v1, _payload}, socket)  do
    Logger.info("born2dieds_cache_updated_v1")
    mng_farm_id = socket.assigns.mng_farm_id
    {
      :noreply,
     socket
     |> assign(:lives, Lives.get_by_mng_farm_id(mng_farm_id))
     |> assign(:cell_states, Cells.get_cell_states(mng_farm_id))
    }
  end

  def handle_info(_msg, socket), do: {:noreply, socket}

  # # def refresh_view(socket) do
  # #   socket
  # #   |> update(
  # #     # lives: Lives.get_all(),
  # #     # farm: socket.assigns.farm,
  # #     # fields: socket.assigns.fields,
  # #     :cell_states, & Cells.get_cell_states(&1.assigns.mng_farm_id)
  # #   )
  # end
end
