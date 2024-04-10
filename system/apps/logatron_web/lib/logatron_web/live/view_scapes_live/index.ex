defmodule LogatronWeb.ViewScapesLive.Index do
  use LogatronWeb, :live_view

  @moduledoc """
  The live view for the scapes index.
  """

  alias Phoenix.PubSub

  alias Logatron.Scapes.{
    Scape,
    Region,
    Farm,
    Animal
  }

  require Logger

  @edge_attached_v1 LogatronCore.Facts.edge_attached_v1()
  @edge_detached_v1 LogatronCore.Facts.edge_detached_v1()

  # @scape_attached_v1 LogatronCore.Facts.scape_attached_v1()

  @initializing_scape_v1 LogatronCore.Facts.initializing_scape_v1()
  @scape_initialized_v1 LogatronCore.Facts.scape_initialized_v1()

  @initializing_region_v1 LogatronCore.Facts.initializing_region_v1()
  @region_initialized_v1 LogatronCore.Facts.region_initialized_v1()

  @initializing_farm_v1 LogatronCore.Facts.initializing_farm_v1()
  @farm_initialized_v1 LogatronCore.Facts.farm_initialized_v1()

  @initializing_animal_v1 LogatronCore.Facts.initializing_animal_v1()
  @animal_initialized_v1 LogatronCore.Facts.animal_initialized_v1()


  @impl true
  def mount(_params, _session, socket) do
    case connected?(socket) do
      true ->
        Logger.info("Connected")
        PubSub.subscribe(Logatron.PubSub, @edge_attached_v1)
        PubSub.subscribe(Logatron.PubSub, @edge_detached_v1)
        # Phoenix.PubSub.subscribe(Logatron.PubSub, @scape_attached_v1)
        PubSub.subscribe(Logatron.PubSub, @initializing_scape_v1)
        PubSub.subscribe(Logatron.PubSub, @initializing_region_v1)
        PubSub.subscribe(Logatron.PubSub, @initializing_farm_v1)
        PubSub.subscribe(Logatron.PubSub, @initializing_animal_v1)

      # Phoenix.PubSub.subscribe(Logatron.PubSub, @scape_initialized_v1)
      false ->
        Logger.info("Not connected")
    end

    {:ok, assign(socket, scapes: [], edges: [], regions: [], farms: [], animals: [])}
  end

  ########## CALLBACKS ##########
  @impl true
  def handle_info({@edge_attached_v1, edge_init}, socket),
    do: {:noreply, try_add_edge(socket, edge_init)}

  @impl true
  def handle_info({@edge_detached_v1, edge_init}, socket),
    do: {:noreply, try_remove_edge(socket, edge_init)}

  @impl true
  def handle_info({@initializing_scape_v1, scape_init}, socket),
    do: {:noreply, try_add_scape(socket, scape_init)}

  def handle_info({@scape_initialized_v1, scape_init}, socket),
    do: {:noreply, assign(socket, scapes: [scape_init | socket.assigns.scapes])}

  @impl true
  def handle_info({@initializing_region_v1, region_init}, socket),
    do: {:noreply, try_add_region(socket, region_init)}

  @impl true
  def handle_info({@region_initialized_v1, region_init}, socket),
    do: {:noreply, assign(socket, regions: [region_init | socket.assigns.regions])}

  @impl true
  def handle_info({@initializing_farm_v1, farm_init}, socket),
    do: {:noreply,  try_add_farm(socket, farm_init)}

  @impl true
  def handle_info({@farm_initialized_v1, farm_init}, socket),
    do: {:noreply, assign(socket, farms: [farm_init | socket.assigns.farms])}

  @impl true
  def handle_info({@initializing_animal_v1, animal_init}, socket),
    do: {:noreply, try_add_animal(socket, animal_init)}

  @impl true
  def handle_info({@animal_initialized_v1, animal_init}, socket),
    do: {:noreply, assign(socket, animals: [animal_init | socket.assigns.animals])}

  ################ INTERNALS ###################


  defp try_add_animal(socket, animal_init) do
    socket
    |> assign(
      action_animal: animal_init.id,
      animals: [animal_init | socket.assigns.animals]
    )
  end


  defp try_add_farm(socket, farm_init) do
    socket
    |> assign(
      action_farm: farm_init.id,
      farms: [farm_init | socket.assigns.farms]
    )
    |> put_flash(:success, "Farm added")
  end

  defp try_add_region(socket, region_init) do
    socket
    |> assign(
      action_region: region_init.id,
      regions: [region_init | socket.assigns.regions]
    )
    |> put_flash(:success, "Region added")
  end

  defp try_add_scape(socket, scape_init) do
    socket
    |> assign(
      action_scape: scape_init.id,
      scapes: [scape_init | socket.assigns.scapes]
    )
  end

  defp try_add_edge(socket, edge_init) do
    socket
    |> assign(
      action_edge: edge_init.id,
      edges: [edge_init | socket.assigns.edges]
    )
  end

  defp try_remove_edge(socket, edge_init) do
    socket
    |> assign(
      action_edge: edge_init.id,
      edges:
        socket.assigns.edges
        |> Enum.filter(fn map -> map.id != edge_init.id end)
    )
    |> put_flash(:warning, "Edge removed")
  end
end
