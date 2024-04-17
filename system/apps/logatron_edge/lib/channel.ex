defmodule LogatronEdge.Channel do
  use GenServer, restart: :transient

  @moduledoc """
  LogatronEdge.Channel is a GenServer that manages a channel to a scape,
  """

  alias LogatronEdge.Client
  alias LogatronCore.Facts

  require Logger

  # @attach_scape_v1 "attach_scape:v1"

  @initializing_scape_v1 Facts.initializing_scape_v1()
  @scape_initialized_v1 Facts.scape_initialized_v1()
  @scape_detached_v1 Facts.scape_detached_v1()

  @initializing_region_v1 Facts.initializing_region_v1()
  @region_initialized_v1 Facts.region_initialized_v1()
  @region_detached_v1 Facts.region_detached_v1()

  @initializing_farm_v1 Facts.initializing_farm_v1()
  @farm_initialized_v1 Facts.farm_initialized_v1()
  @farm_detached_v1 Facts.farm_detached_v1()

  @initializing_animal_v1 Facts.initializing_animal_v1()
  @animal_initialized_v1 Facts.animal_initialized_v1()

  ############ API ##########
  # def attach_scape(scape_init),
  #   do:
  #     GenServer.cast(
  #       via(scape_init.id),
  #       {:attach_scape, scape_init}
  #     )

  def initializing_scape(scape_init),
    do:
      GenServer.cast(
        via(scape_init.id),
        {:initializing_scape, scape_init}
      )

  def scape_initialized(scape_init),
    do:
      GenServer.cast(
        via(scape_init.id),
        {:scape_initialized, scape_init}
      )

  def scape_detached(scape_init),
    do:
      GenServer.cast(
        via(scape_init.id),
        {:scape_detached, scape_init}
      )

  def initializing_region(region_init),
    do:
      GenServer.cast(
        via(region_init.scape_id),
        {:initializing_region, region_init}
      )

  def region_initialized(region_init),
    do:
      GenServer.cast(
        via(region_init.scape_id),
        {:region_initialized, region_init}
      )

  def region_detached(region_init),
    do:
      GenServer.cast(
        via(region_init.scape_id),
        {:region_detached, region_init}
      )

  def initializing_farm(farm_init),
    do:
      GenServer.cast(
        via(farm_init.scape_id),
        {:initializing_farm, farm_init}
      )

  def farm_initialized(farm_init),
    do:
      GenServer.cast(
        via(farm_init.scape_id),
        {:farm_initialized, farm_init}
      )

  def farm_detached(farm_init),
    do:
      GenServer.cast(
        via(farm_init.scape_id),
        {:farm_detached, farm_init}
      )

  def emit_initializing_animal(animal_init),
    do:
      GenServer.cast(
        via(animal_init.scape_id),
        {:initializing_animal, animal_init}
      )

  def emit_animal_initialized(animal_init),
    do:
      GenServer.cast(
        via(animal_init.scape_id),
        {:animal_initialized, animal_init}
      )

  ########### CALLBACKS ################

  @impl true
  def handle_cast({:scape_detached, scape_init}, state) do
    Client.publish(
      scape_init.edge_id,
      @scape_detached_v1,
      %{scape_init: scape_init}
    )

    {:noreply, state}
  end

  @impl true
  def handle_cast({:initializing_animal, animal_init}, state) do
    %{edge_id: edge_id} = state

    Client.publish(
      edge_id,
      @initializing_animal_v1,
      %{animal_init: animal_init}
    )

    {:noreply, state}
  end

  @impl true
  def handle_cast({:animal_initialized, animal_init}, state) do
    %{edge_id: edge_id} = state

    Client.publish(
      edge_id,
      @animal_initialized_v1,
      %{animal_init: animal_init}
    )

    {:noreply, state}
  end

  @impl true
  def handle_cast({:initializing_farm, farm_init}, state) do
    %{edge_id: edge_id} = state

    Client.publish(
      edge_id,
      @initializing_farm_v1,
      %{farm_init: farm_init}
    )

    {:noreply, state}
  end

  @impl true
  def handle_cast({:farm_initialized, farm_init}, state) do
    %{edge_id: edge_id} = state

    Client.publish(
      edge_id,
      @farm_initialized_v1,
      %{farm_init: farm_init}
    )

    {:noreply, state}
  end

  @impl true
  def handle_cast({:farm_detached, farm_init}, state) do
    Client.publish(
      farm_init.edge_id,
      @farm_detached_v1,
      %{farm_init: farm_init}
    )

    {:noreply, state}
  end

  @impl true
  def handle_cast({:initializing_region, region_init}, %{edge_id: edge_id} = state) do
    Client.publish(
      edge_id,
      @initializing_region_v1,
      %{region_init: region_init}
    )

    {:noreply, state}
  end

  @impl true
  def handle_cast({:region_initialized, region_init}, %{edge_id: edge_id} = state) do
    Client.publish(
      edge_id,
      @region_initialized_v1,
      %{region_init: region_init}
    )

    {:noreply, state}
  end

  @impl true
  def handle_cast({:region_detached, region_init}, state) do
    Client.publish(
      region_init.edge_id,
      @region_detached_v1,
      %{region_init: region_init}
    )

    {:noreply, state}
  end

  @impl true
  def handle_cast({:initializing_scape, scape_init}, state) do
    %{edge_id: edge_id} = state

    Client.publish(
      edge_id,
      @initializing_scape_v1,
      %{scape_init: scape_init}
    )

    {:noreply, state}
  end

  @impl true
  def handle_cast({:scape_initialized, scape_init}, state) do
    %{edge_id: edge_id} = state

    Client.publish(
      edge_id,
      @scape_initialized_v1,
      %{scape_init: scape_init}
    )

    {:noreply, state}
  end

  @impl true
  def init(scape_init) do
    {:ok, scape_init}
  end

  ############### PLUMBING ##############
  def child_spec(scape_init),
    do: %{
      id: via(scape_init.id),
      start: {__MODULE__, :start_link, [scape_init]},
      type: :worker
    }

  def to_name(key) when is_bitstring(key),
    do: "logatron_edge.scape.channel.#{key}"

  def via(key),
    do: Logatron.Registry.via_tuple({:channel, to_name(key)})

  def start_link(scape_init),
    do:
      GenServer.start_link(
        __MODULE__,
        scape_init,
        name: via(scape_init.id)
      )
end
