defmodule LogatronWeb.EdgeChannel do
  use LogatronWeb, :channel

  @moduledoc """
  The EdgeChannel is used to broadcast messages to all clients
  """
  require Logger
  require Phoenix.PubSub

  alias LogatronWeb.Dispatch.EdgePresence
  alias LogatronWeb.Dispatch.EdgeHandler
  alias LogatronWeb.Dispatch.ScapeHandler
  alias LogatronWeb.Dispatch.RegionHandler
  alias LogatronWeb.Dispatch.FarmHandler
  alias LogatronWeb.Dispatch.Born2DiedHandler, as: LifeHandler
  alias LogatronWeb.Dispatch.ChannelWatcher


  alias Edge.Facts, as: EdgeFacts
  alias Scape.Facts, as: ScapeFacts
  alias Region.Facts, as: RegionFacts
  alias Organization.Facts, as: FarmFacts
  alias Born2Died.Facts, as: LifeFacts

  @fact_born "fact:born"
  @fact_died "fact:died"
  @hope_shout "hope:shout"
  @hope_ping "ping"
  @hope_join_edge "join_edge"

  # @scape_attached_v1 Facts.scape_attached_v1()

  @edge_attached_v1 EdgeFacts.edge_attached_v1()

  @initializing_scape_v1 ScapeFacts.initializing_scape_v1()
  @scape_initialized_v1 ScapeFacts.scape_initialized_v1()
  @scape_detached_v1 ScapeFacts.scape_detached_v1()

  @initializing_region_v1 RegionFacts.initializing_region_v1()
  @region_initialized_v1 RegionFacts.region_initialized_v1()

  @initializing_farm_v1 FarmFacts.initializing_farm_v1()
  @farm_initialized_v1 FarmFacts.farm_initialized_v1()
  @farm_detached_v1 FarmFacts.farm_detached_v1()

  @initializing_life_v1 LifeFacts.initializing_life_v1()
  @life_initialized_v1 LifeFacts.life_initialized_v1()
  @life_state_changed_v1 LifeFacts.life_state_changed_v1()
  @life_died_v1 LifeFacts.life_died_v1()

  @life_moved_v1 LifeFacts.life_moved_v1()

  # @edge_detached_v1 EdgeFacts.edge_detached_v1()
  @edge_attached_v1 EdgeFacts.edge_attached_v1()

  # @attach_scape_v1 "attach_scape:v1"

  @presence_changed_v1 EdgeFacts.presence_changed_v1()

  ################ CALLBACKS ################
  @impl true
  def join("edge:lobby", edge_init, socket) do
    send(self(), :after_join)

    ChannelWatcher.monitor(
      "edge:lobby",
      self(),
      {EdgeHandler, :pub_edge_detached, [%{"edge_init" => edge_init}]}
    )

    {:ok, socket}
  end

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
    # Logger.debug("EdgeChannel.handle_in: #{@hope_ping} #{inspect(payload)}")
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
    # Logger.debug("EdgeChannel.handle_in (#{inspect(@fact_born)}): #{inspect(payload)}")
    topic = to_topic(payload["edge_id"])
    Phoenix.PubSub.broadcast(Logatron.PubSub, topic, @fact_born, payload)
    {:noreply, socket}
  end

  @impl true
  def handle_in(@fact_died, payload, socket) do
    # Logger.debug("EdgeChannel.handle_in: #{@fact_died} #{inspect(payload)}")
    topic = to_topic(payload["edge_id"])
    Phoenix.PubSub.broadcast(Logatron.PubSub, topic, @fact_died, payload)
    {:noreply, socket}
  end

  # @impl true
  # def handle_in(@attach_scape_v1, scape_init, socket),
  #   do: LogatronWeb.ScapeHandler.attach_scape_v1(scape_init, socket)

  @impl true
  def handle_in(@edge_attached_v1, payload, socket) do
    # Logger.info("#{@edge_attached_v1} #{inspect(payload)}")
    EdgeHandler.pub_edge_attached(payload)
    {:reply, {:ok, payload}, socket}
  end

  @impl true
  def handle_in(@initializing_scape_v1, payload, socket) do
    Logger.alert("EdgeChannel.handle_in: #{@initializing_scape_v1} #{inspect(payload)}")
    ScapeHandler.pub_initializing_scape_v1(payload, socket)
  end

  @impl true
  def handle_in(@scape_initialized_v1, payload, socket) do
    Logger.alert("EdgeChannel.handle_in: #{@scape_initialized_v1} #{inspect(payload)}")
    ScapeHandler.pub_scape_initialized_v1(payload, socket)
  end

  @impl true
  def handle_in(@scape_detached_v1, payload, socket) do
    # Logger.debug("EdgeChannel.handle_in: #{@scape_detached_v1} #{inspect(payload)}")
    ScapeHandler.pub_scape_detached_v1(payload, socket)
  end

  @impl true
  def handle_in(@initializing_region_v1, payload, socket) do
    # Logger.debug("EdgeChannel.handle_in: #{@initializing_region_v1} #{inspect(payload)}")
    RegionHandler.pub_initializing_region_v1(payload, socket)
  end

  @impl true
  def handle_in(@region_initialized_v1, payload, socket) do
    # Logger.debug("EdgeChannel.handle_in: #{@region_initialized_v1} #{inspect(payload)}")
    RegionHandler.pub_region_initialized_v1(payload, socket)
  end

  @impl true
  def handle_in(@initializing_farm_v1, payload, socket) do
    # Logger.debug("EdgeChannel.handle_in: #{@initializing_farm_v1} #{inspect(payload)}")
    FarmHandler.pub_initializing_farm_v1(payload, socket)
  end

  @impl true
  def handle_in(@farm_initialized_v1, payload, socket) do
    # Logger.debug("EdgeChannel.handle_in: #{@farm_initialized_v1} #{inspect(payload)}")
    FarmHandler.pub_farm_initialized_v1(payload, socket)
  end

  @impl true
  def handle_in(@farm_detached_v1, payload, socket) do
    # Logger.debug("EdgeChannel.handle_in: #{@farm_detached_v1} #{inspect(payload)}")
    FarmHandler.pub_farm_detached_v1(payload, socket)
  end

  @impl true
  def handle_in(@initializing_life_v1, payload, socket) do
    # Logger.debug("EdgeChannel.handle_in: #{@initializing_life_v1} #{inspect(payload)}")
    LifeHandler.pub_initializing_animal_v1(payload, socket)
  end

  @impl true
  def handle_in(@life_initialized_v1, payload, socket) do
    # Logger.debug("EdgeChannel.handle_in: #{@life_initialized_v1} #{inspect(payload)}")
    LifeHandler.pub_animal_initialized_v1(payload, socket)
  end

  def handle_in(@life_died_v1, payload, socket) do
    # Logger.debug("EdgeChannel.handle_in: #{@life_died_v1} #{inspect(payload)}")
    LifeHandler.pub_life_died_v1(payload, socket)
  end

  @impl true
  def handle_in(@life_state_changed_v1, payload, socket) do
    # Logger.debug("EdgeChannel.handle_in: #{@life_state_changed_v1} #{inspect(payload)}")
    LifeHandler.pub_life_state_changed_v1(payload, socket)
  end

  @impl true
  def handle_in(@life_moved_v1, payload, socket) do
    # Logger.debug("EdgeChannel.handle_in: #{@life_moved_v1} #{inspect(payload)}")
    LifeHandler.pub_life_moved_v1(payload, socket)
  end

  ################ INTERNALS ################
  defp to_topic(edge_id),
    do: "edge:lobby:#{edge_id}"
end
