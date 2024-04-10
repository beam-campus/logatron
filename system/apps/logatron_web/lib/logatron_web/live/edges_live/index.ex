defmodule LogatronWeb.EdgesLive.Index do
  use LogatronWeb, :live_view

  require Logger

  alias Logatron.Edges.Cache
  alias Phoenix.PubSub

  @edge_attached_v1 LogatronCore.Facts.edge_attached_v1()
  @edge_detached_v1 LogatronCore.Facts.edge_detached_v1()
  @impl true
  def mount(_params, _session, socket) do
    case connected?(socket) do
      true ->
        Logger.info("Connected")
        PubSub.subscribe(Logatron.PubSub, @edge_attached_v1)
        PubSub.subscribe(Logatron.PubSub, @edge_detached_v1)
        # Phoenix.PubSub.subscribe(Logatron.PubSub, @scape_attached_v1)
        {:ok, refresh_edges(socket)}

      # Phoenix.PubSub.subscribe(Logatron.PubSub, @scape_initialized_v1)
      false ->
        Logger.info("Not connected")
        {:ok, refresh_edges(socket)}
    end
  end

  ########## CALLBACKS ##########
  @impl true
  def handle_info({@edge_attached_v1, _edge_init}, socket),
    do: {:noreply, refresh_edges(socket)}

  @impl true
  def handle_info({@edge_detached_v1, _edge_init}, socket),
    do: {:noreply, refresh_edges(socket)}

  ####################### INTERNALS #######################

  defp refresh_edges(socket),
    do:
      socket
      |> assign(:edges, Cache.get_all())

  # defp init_edges(socket),
  #   do:
  #     socket
  #     |> assign(:edges, [])

  # def add_edge(socket, edge),
  #   do:
  #     socket
  #     |> assign(:edges, [edge | socket.assigns.edges])

  # def remove_edge(socket, edge),
  #   do:
  #     socket
  #     |> assign(:edges, List.delete(socket.assigns.edges, edge))

end
