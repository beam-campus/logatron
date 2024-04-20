defmodule LogatronWeb.ViewBorn2DiedsLive.Index do
  use LogatronWeb, :live_view

  require Logger
  require Seconds

  alias Logatron.Edges.Server, as: EdgesCache
  alias Logatron.Born2Dieds.Server, as: Born2DiedsCache

  alias Phoenix.PubSub
  alias LogatronCore.Facts

  @born2dieds_cache_updated_v1 Facts.born2dieds_cache_updated_v1()
  @edges_cache_updated_v1 Facts.edges_cache_updated_v1()
  @initializing_born2died_v1 Facts.initializing_born2died_v1()
  @born2died_initialized_v1 Facts.born2died_initialized_v1()
  @born2died_state_changed_v1 Facts.born2died_state_changed_v1()
  @edge_attached_v1 Facts.edge_attached_v1()
  @edge_detached_v1 Facts.edge_detached_v1()
  @born2died_died_v1 Facts.born2died_died_v1()

  # def refresh(_caller_state),
  #   do: Process.send(self(), :refresh, @refresh_seconds * 1_000)

  def get_born2dieds_summary(born2dieds),
    do:
      GenServer.call(
        __MODULE__,
        {:get_born2dieds_summary, born2dieds}
      )

  @impl true
  def handle_call({:get_born2dieds_summary, born2dieds}, _from, state) do
    {
      :reply,
      born2dieds
      |> Stream.map(fn {:entry, _, _, _, life} -> life end)
      |> Enum.reduce(%{}, fn life, acc ->
        Map.update(acc, %{name: life.name, id: life.id}, 1, &(&1 + 1))
      end)
      |> Map.to_list()
      |> Enum.sort()
      |> Enum.map(fn {%{id: id, name: name}, count} -> {id, %{name: name, count: count}} end),
      state
    }
  end

  @impl true
  def mount(_params, _session, socket) do
    case connected?(socket) do
      true ->
        Logger.info("Connected")

        PubSub.subscribe(Logatron.PubSub, @born2dieds_cache_updated_v1)
        PubSub.subscribe(Logatron.PubSub, @edges_cache_updated_v1)
        PubSub.subscribe(Logatron.PubSub, @initializing_born2died_v1)
        PubSub.subscribe(Logatron.PubSub, @born2died_initialized_v1)
        PubSub.subscribe(Logatron.PubSub, @born2died_state_changed_v1)
        PubSub.subscribe(Logatron.PubSub, @edge_detached_v1)

        {
          :ok,
          socket
          |> assign(
            edges: EdgesCache.get_all(),
            born2dieds: Born2DiedsCache.get_all()
          )
        }

      false ->
        Logger.info("Not connected")

        {
          :ok,
          socket
          |> assign(
            edges: EdgesCache.get_all(),
            born2dieds: Born2DiedsCache.get_all()
          )
        }
    end
  end

  @impl true
  def handle_info({@edge_attached_v1, _payload}, socket),
    do: {
      :noreply,
      socket
      |> assign(edges: EdgesCache.get_all())
    }

    @impl true
  def handle_info({@edge_detached_v1, _payload}, socket),
    do: {
      :noreply,
      socket
      |> assign(edges: EdgesCache.get_all())
    }

  @impl true
  def handle_info({@edges_cache_updated_v1, _payload}, socket),
    do: {
      :noreply,
      socket
      |> assign(
        edges: EdgesCache.get_all(),
        born2dieds: Born2DiedsCache.get_all(),
        now: DateTime.utc_now()
      )
    }

  @impl true
  def handle_info({@born2dieds_cache_updated_v1, _payload}, socket),
    do: {
      :noreply,
      socket
      |> assign(
        born2dieds: Born2DiedsCache.get_all(),
        now: DateTime.utc_now()
      )
    }

  @impl true
  def handle_info({@initializing_born2died_v1, _born2died_init}, socket) do
    {
      :noreply,
      socket
      |> assign(born2dieds: Born2DiedsCache.get_all())
    }
  end


  @impl true
  def handle_info({@born2died_initialized_v1, _born2died_init}, socket) do
    {
      :noreply,
      socket
      |> assign(born2dieds: Born2DiedsCache.get_all())
    }
  end

  @impl true
  def handle_info({@born2died_state_changed_v1, _payload}, socket) do
    {
      :noreply,
      socket
      |> assign(born2dieds: Born2DiedsCache.get_all())
    }
  end


  def handle_info({@born2died_died_v1, born2died_state}, socket) do
    {
      :noreply,
      socket
      |> assign(born2dieds: Born2DiedsCache.get_all())
    }

  end



  # @impl true
  # def handle_info(msg, socket) do
  #   Logger.error("Unhandled message: #{inspect(msg)}")
  #   {:noreply, socket}
  # end
end
