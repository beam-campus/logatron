defmodule LogatronWeb.ViewFarmsLive.Index do
  use LogatronWeb, :live_view

  alias Phoenix.PubSub
  alias LogatronCore.Facts

  require Logger

  @edges_cache_updated_v1 Facts.edges_cache_updated_v1()
  # @scapes_cache_updated_v1 Facts.scapes_cache_updated_v1()
  # @regions_cache_updated_v1 Facts.regions_cache_updated_v1()
  @farms_cache_updated_v1 Facts.farms_cache_updated_v1()

  @impl true
  def mount(_params, _session, socket) do
    case connected?(socket) do
      true ->
        Logger.info("Connected")
        PubSub.subscribe(Logatron.PubSub, @edges_cache_updated_v1)
        PubSub.subscribe(Logatron.PubSub, @farms_cache_updated_v1)

        {
          :ok,
          socket
          |> assign(
            farms: Logatron.MngFarms.Server.get_all(),
            edges: Logatron.Edges.Server.get_all()
          )
        }

      false ->
        Logger.info("Not connected")

        {:ok,
         socket
         |> assign(
           farms: [],
           edges: []
         )}
    end
  end

  @impl true
  def handle_info({@edges_cache_updated_v1, _payload}, socket),
    do: {
      :noreply,
      socket
      |> assign(:farms, Logatron.Edges.Server.get_all())
    }

  @impl true
  def handle_info({@farms_cache_updated_v1, _payload}, socket),
    do: {
      :noreply,
      socket
      |> assign(:farms, Logatron.MngFarms.Server.get_all())
    }
end
