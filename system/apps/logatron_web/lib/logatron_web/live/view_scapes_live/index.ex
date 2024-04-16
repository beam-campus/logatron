defmodule LogatronWeb.ViewScapesLive.Index do
  use LogatronWeb, :live_view

  @moduledoc """
  The live view for the scapes index.
  """

  alias Phoenix.PubSub

  alias Logatron.Scapes.{
    Scape,
    Region
  }

  require Logger

  alias LogatronCore.Facts

  @edges_cache_updated_v1 Facts.edges_cache_updated_v1()
  @scapes_cache_updated_v1 Facts.scapes_cache_updated_v1()
  @regions_cache_updated_v1 Facts.regions_cache_updated_v1()



  @edge_attached_v1 Facts.edge_attached_v1()
  @edge_detached_v1 Facts.edge_detached_v1()

  # @scape_attached_v1 LogatronCore.Facts.scape_attached_v1()
  @initializing_scape_v1 Facts.initializing_scape_v1()
  # @scape_initialized_v1 LogatronCore.Facts.scape_initialized_v1()
  # @scape_detached_v1 LogatronCore.Facts.scape_detached_v1()

  @initializing_region_v1 Facts.initializing_region_v1()
  @region_initialized_v1 Facts.region_initialized_v1()

  @initializing_farm_v1 Facts.initializing_farm_v1()
  @farm_initialized_v1 Facts.farm_initialized_v1()

  @initializing_animal_v1 Facts.initializing_animal_v1()
  @animal_initialized_v1 Facts.animal_initialized_v1()

  @impl true
  def mount(_params, _session, socket) do
    case connected?(socket) do
      true ->
        Logger.info("Connected")
        PubSub.subscribe(Logatron.PubSub, @edges_cache_updated_v1)
        PubSub.subscribe(Logatron.PubSub, @scapes_cache_updated_v1)


      false ->
        Logger.info("Not connected")
    end

    {:ok,
     socket
     |> assign(
       scapes: Logatron.Scapes.Server.get_all(),
       edges: Logatron.Edges.Cache.get_all(),
       regions: Logatron.Regions.Server.get_all()
     )}
  end

  ########## CALLBACKS ##########

  @impl true
  def handle_info({@edge_attached_v1, payload}, socket) do
    {
      :noreply,
      socket
      |> assign(edges: Logatron.Edges.Cache.get_all())
      |> put_flash(:success, "Edges updated")
    }
  end

  @impl true
  def handle_info({@edge_detached_v1, payload}, socket) do
    {
      :noreply,
      socket
      |> assign(edges: Logatron.Edges.Cache.get_all())
      |> put_flash(:success, "Edges updated")
    }
  end

  @impl true
  def handle_info({@initializing_scape_v1, payload}, socket) do
    Logger.info("Scapes updated, #{inspect(payload)}")
    {
      :noreply,
      socket
      |> assign(scapes: Logatron.Scapes.Server.get_all())
      |> put_flash(:success, "Scapes updated")
    }
  end

  @impl true
  def handle_info({@initializing_region_v1}, socket) do

  end

  @impl true
  def handle_info(msg, socket) do
    Logger.info("Received message: #{inspect(msg)}")
    {:noreply, socket}
  end

  ################ INTERNALS ###################


end
