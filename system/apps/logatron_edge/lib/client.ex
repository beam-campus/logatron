defmodule LogatronEdge.Client do
  use Slipstream
  @moduledoc """
  LogatronEdge.Client is the client-side of the LogatronEdge.Socket server.
  It is part of the main application supervision tree.
  """
  require Logger

  alias LogatronCore.Facts

  @edge_lobby "edge:lobby"
  @edge_attached_v1 Facts.edge_attached_v1()
  @presence_changed_v1 Facts.presence_changed_v1()
  # @joined_edge_lobby "edge:lobby:joined"

  ############# API ################
  def publish(edge_id, event, payload) do
    GenServer.cast(
      via(edge_id),
      {:publish, @edge_lobby, event, payload}
    )
  end


  ############# CALLBACKS ################
  @impl Slipstream
  def handle_cast({:publish, topic, event, payload}, socket) do
    socket
    |> push(topic, event, payload)
    {:noreply, socket}
  end


  @impl Slipstream
  def init(args) do
    socket =
      new_socket()
      |> assign(:edge_init, args.edge_init)
      |> connect!(args.config)
    {:ok, socket, {:continue, :start_ping}}
  end

  @impl Slipstream
  def handle_connect(socket) do
    {:ok, join(socket, @edge_lobby, %{edge_init: socket.assigns.edge_init})}
  end

  @impl Slipstream
  def handle_join(@edge_lobby, _join_response, socket) do
    push(socket, @edge_lobby, @edge_attached_v1, %{edge_init: socket.assigns.edge_init})
    # {:noreply, socket}
    {:ok, socket}
  end

  @impl Slipstream
  def handle_disconnect(_reason, socket) do
    {:stop, :normal, socket}
  end

  @impl Slipstream
  def handle_continue(:start_ping, socket) do
    {:noreply, socket}
  end


  @impl Slipstream
  def handle_info({:after_join, _}, socket) do
    Logger.debug("Edge.Client received: :after_join")
    {:noreply, socket}
  end

  @impl Slipstream
  def handle_info({@presence_changed_v1, presence_list}, socket) do
    Logger.debug("Edge.Client received: [#{@presence_changed_v1}] \n #{inspect(presence_list)}")
    {:noreply, socket}
  end

  @impl Slipstream
  def handle_info(msg, socket) do
    Logger.debug("Edge.Client received: #{inspect(msg)}")
    {:noreply, socket}
  end



  ############ PLUMBING ################
  def to_name(edge_id),
    do: "edge.client:#{edge_id}"

  def to_topic(edge_id),
    do: "edge:lobby:#{edge_id}"

  def via(edge_id),
    do: Logatron.Registry.via_tuple({:client, to_name(edge_id)})

  def child_spec(edge_init) do
    config = Application.fetch_env!(:logatron_edge, __MODULE__)

    %{
      id: to_name(edge_init.id),
      start: {__MODULE__, :start_link, [%{config: config, edge_init: edge_init}]},
      restart: :transient,
      type: :worker
    }
  end

  def start_link(args),
    do:
      Slipstream.start_link(
        __MODULE__,
        args,
        name: via(args.edge_init.id)
      )
end
