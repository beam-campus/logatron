defmodule LogatronWeb.EdgesLive.Index do
  use LogatronWeb, :live_view

  require Logger
  require Seconds

  alias Logatron.Edges.Cache
  alias Phoenix.PubSub

  @edge_attached_v1 LogatronCore.Facts.edge_attached_v1()
  @edge_detached_v1 LogatronCore.Facts.edge_detached_v1()
  @refresh_seconds 1

  # def refresh(_caller_state),
  #   do: Process.send(self(), :refresh, @refresh_seconds * 1_000)

  @impl true
  def mount(_params, _session, socket) do
    # Cronlike.start_link(%{
    #   interval: :rand.uniform(@refresh_seconds),
    #   unit: :second,
    #   callback_function: &handle_info(:refresh, &1),
    #   caller_state: socket
    # })


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

  # @impl true
  # def handle_info(:refresh, socket) do
  #   {:noreply, socket |> redirect(to: "/") }
  # end

  ####################### INTERNALS #######################

  defp refresh_edges(socket),
    do:
      socket
      |> assign(:edges, Cache.get_all())
      |> assign(:now, DateTime.utc_now())

end
