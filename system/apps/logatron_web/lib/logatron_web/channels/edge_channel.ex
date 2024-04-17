defmodule LogatronWeb.EdgeChannel do
  use LogatronWeb, :channel

  @moduledoc """
  The EdgeChannel is used to broadcast messages to all clients
  """
  require Logger
  require Phoenix.PubSub
  require LogatronCore.Facts

  alias LogatronWeb.Dispatch.{
    EdgePresence,
    EdgeHandler,
    ScapeHandler,
    RegionHandler,
    FarmHandler,
    AnimalHandler
  }

  alias LogatronCore.Facts

  @fact_born "fact:born"
  @fact_died "fact:died"
  @hope_shout "hope:shout"
  @hope_ping "ping"
  @hope_join_edge "join_edge"
  @edge_attached_v1 Facts.edge_attached_v1()

  # @scape_attached_v1 Facts.scape_attached_v1()

  @initializing_scape_v1 Facts.initializing_scape_v1()
  @scape_initialized_v1 Facts.scape_initialized_v1()
  @scape_detached_v1 Facts.scape_detached_v1()

  @initializing_region_v1 Facts.initializing_region_v1()
  @region_initialized_v1 Facts.region_initialized_v1()

  @initializing_farm_v1 Facts.initializing_farm_v1()
  @farm_initialized_v1 Facts.farm_initialized_v1()
  @farm_detached_v1 Facts.farm_detached_v1()

  @initializing_animal_v1 Facts.initializing_animal_v1()
  @animal_initialized_v1 Facts.animal_initialized_v1()

  # @attach_scape_v1 "attach_scape:v1"

  @presence_changed_v1 Facts.presence_changed_v1()

  ################ CALLBACKS ################
  @impl true
  def join("edge:lobby", edge_init, socket),
    do: EdgeHandler.handle_join("edge:lobby", edge_init, socket)

  @impl true
  def handle_info(:after_join, socket) do
    Logger.info(":after_join #{inspect(socket)}")

    {:ok, _} =
      EdgePresence.track(socket, "edge_1", %{
        online_at: inspect(System.system_time(:second))
      })

    broadcast(socket, @presence_changed_v1, EdgePresence.list(socket))

    {:noreply, socket}
  end

  @impl true
  def handle_in("hello", payload, socket) do
    Logger.debug("in: 'hello' #{inspect(payload)}")
    {:reply, {:ok, payload}, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in(@hope_ping, payload, socket) do
    Logger.debug("EdgeChannel.handle_in: #{@hope_ping} #{inspect(payload)}")
    {:reply, {:ok, payload}, socket}
  end

  @impl true
  def handle_in(@hope_join_edge, payload, socket) do
    broadcast(socket, @hope_shout, payload)
    {:noreply, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (farm:lobby).
  @impl true
  def handle_in(@hope_shout, payload, socket) do
    broadcast(socket, @hope_shout, payload)
    {:noreply, socket}
  end

  # We might want to use GenStage, GenFlow or Broadway at a later moment,
  # instead of publishing it on PubSub (should PubSub be a bottleneck).
  @impl true
  def handle_in(@fact_born, payload, socket) do
    Logger.debug("EdgeChannel.handle_in (#{inspect(@fact_born)}): #{inspect(payload)}")
    topic = to_topic(payload["edge_id"])
    Phoenix.PubSub.broadcast(Logatron.PubSub, topic, @fact_born, payload)
    {:noreply, socket}
  end

  @impl true
  def handle_in(@fact_died, payload, socket) do
    Logger.debug("EdgeChannel.handle_in: #{@fact_died} #{inspect(payload)}")
    topic = to_topic(payload["edge_id"])
    Phoenix.PubSub.broadcast(Logatron.PubSub, topic, @fact_died, payload)
    {:noreply, socket}
  end

  # @impl true
  # def handle_in(@attach_scape_v1, scape_init, socket),
  #   do: LogatronWeb.ScapeHandler.attach_scape_v1(scape_init, socket)

  @impl true
  def handle_in(@edge_attached_v1, payload, socket) do
    Logger.info("#{@edge_attached_v1} #{inspect(payload)}")
    EdgeHandler.pub_edge_attached(payload, socket)
    {:reply, {:ok, payload}, socket}
  end

  @impl true
  def handle_in(@initializing_scape_v1, payload, socket) do
    Logger.debug("EdgeChannel.handle_in: #{@initializing_scape_v1} #{inspect(payload)}")
    ScapeHandler.pub_initializing_scape_v1(payload, socket)
  end

  @impl true
  def handle_in(@scape_initialized_v1, payload, socket) do
    Logger.debug("EdgeChannel.handle_in: #{@scape_initialized_v1} #{inspect(payload)}")
    ScapeHandler.pub_scape_initialized_v1(payload, socket)
  end

  @impl true
  def handle_in(@scape_detached_v1, payload, socket) do
    Logger.debug("EdgeChannel.handle_in: #{@scape_detached_v1} #{inspect(payload)}")
    ScapeHandler.pub_scape_detached_v1(payload, socket)
  end

  @impl true
  def handle_in(@initializing_region_v1, payload, socket) do
    Logger.debug("EdgeChannel.handle_in: #{@initializing_region_v1} #{inspect(payload)}")
    RegionHandler.pub_initializing_region_v1(payload, socket)
  end

  @impl true
  def handle_in(@region_initialized_v1, payload, socket) do
    Logger.debug("EdgeChannel.handle_in: #{@region_initialized_v1} #{inspect(payload)}")
    RegionHandler.pub_region_initialized_v1(payload, socket)
  end

  @impl true
  def handle_in(@initializing_farm_v1, payload, socket) do
    Logger.debug("EdgeChannel.handle_in: #{@initializing_farm_v1} #{inspect(payload)}")
    FarmHandler.pub_initializing_farm_v1(payload, socket)
  end

  @impl true
  def handle_in(@farm_initialized_v1, payload, socket) do
    Logger.debug("EdgeChannel.handle_in: #{@farm_initialized_v1} #{inspect(payload)}")
    FarmHandler.pub_farm_initialized_v1(payload, socket)
  end

  @impl true
  def handle_in(@farm_detached_v1, payload, socket) do
    Logger.debug("EdgeChannel.handle_in: #{@farm_detached_v1} #{inspect(payload)}")
    FarmHandler.pub_farm_detached_v1(payload, socket)
  end

  @impl true
  def handle_in(@initializing_animal_v1, payload, socket) do
    Logger.debug("EdgeChannel.handle_in: #{@initializing_animal_v1} #{inspect(payload)}")
    AnimalHandler.pub_initializing_animal_v1(payload, socket)
  end


  @impl true
  def handle_in(@animal_initialized_v1, payload, socket) do
    Logger.debug("EdgeChannel.handle_in: #{@animal_initialized_v1} #{inspect(payload)}")
    AnimalHandler.pub_animal_initialized_v1(payload, socket)
  end

  ################ INTERNALS ################
  defp to_topic(edge_id),
    do: "edge:lobby:#{edge_id}"
end
