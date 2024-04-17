defmodule LogatronWeb.ViewRegionsLive.Index do
  use LogatronWeb, :live_view

  alias Phoenix.PubSub
  alias LogatronCore.Facts

  require Logger

  @regions_cache_updated_v1 Facts.regions_cache_updated_v1()
  @edges_cache_updated_v1 Facts.edges_cache_updated_v1()


  @impl true
  def mount(_params, _session, socket) do
    case connected?(socket) do
      true ->
        Logger.info("Connected")
        PubSub.subscribe(Logatron.PubSub, @regions_cache_updated_v1)
        PubSub.subscribe(Logatron.PubSub, @edges_cache_updated_v1)

        {
          :ok,
          socket
          |> assign(
            edges: Logatron.Edges.Server.get_all(),
            regions: Logatron.Regions.Server.get_all()
          )
        }

      false ->
        Logger.info("Not connected")
        {:ok, socket |> assign(
          edges: [],
          regions: [])
        }
    end
  end

  @impl true
  def handle_info({@edges_cache_updated_v1, _payload}, socket),
    do: {
      :noreply,
      socket
      |> assign(:regions, Logatron.Edges.Server.get_all())
    }

  @impl true
  def handle_info({@regions_cache_updated_v1, _payload}, socket),
    do: {
      :noreply,
      socket
      |> assign(:regions, Logatron.Regions.Server.get_all())
    }
end
