defmodule Logatron.Born2Dieds.Server do
  use GenServer

  @moduledoc """
  Logatron.Born2Dieds.Server contains the Cache for the Born2Died processes.
  """

  require Cachex
  require Logger

  alias Phoenix.PubSub
  alias LogatronCore.Facts

  @initializing_born2died_v1 Facts.initializing_born2died_v1()
  @born2died_initialized_v1 Facts.born2died_initialized_v1()
  @born2died_detached_v1 Facts.born2died_detached_v1()

  @born2died_state_changed_v1 Facts.born2died_state_changed_v1()

  @born2dieds_cache_updated_v1 Facts.born2dieds_cache_updated_v1()

  ################### PUBLIC API ##################

  def get_all(),
    do:
      GenServer.call(
        __MODULE__,
        {:get_all}
      )

  def get_stream(),
    do:
      GenServer.call(
        __MODULE__,
        {:get_stream}
      )

  def count(),
    do:
      GenServer.call(
        __MODULE__,
        {:count}
      )

  def save(state),
    do:
      GenServer.cast(
        __MODULE__,
        {:save, state}
      )

  ################### CALLBACKS ###################

  @impl GenServer
  def init(opts) do
    Logger.info("Starting born2dieds cache")

    :born2dieds_cache
    |> Cachex.start()

    # PubSub.subscribe(Logatron.PubSub, @initializing_born2died_v1)
    # PubSub.subscribe(Logatron.PubSub, @born2died_detached_v1)


    {:ok, opts}
  end

  ################### handle_cast ###################

  @impl GenServer
  def handle_cast({:save, born2died_init}, state) do
    Logger.debug("Saving born2died_init: #{inspect(born2died_init)}")
    :born2dieds_cache
    |> Cachex.put!(born2died_init.id, born2died_init)

    notify_born2dieds_updated({@born2died_initialized_v1, born2died_init})
    {:noreply, state}
  end

  ################### handle_call ###################

  @impl GenServer
  def handle_call({:get_all}, _from, state) do
    {
      :reply,
      :born2dieds_cache
      |> Cachex.stream!()
      |> Enum.map(fn {:entry, _key, _nil, _internal_id, born2died_init} -> born2died_init end)
      |> Enum.sort_by(& &1.vitals.age)
      |> Enum.reverse(),
      state
    }
  end

  @impl GenServer
  def handle_call({:get_stream}, _from, state) do
    {
      :reply,
      :born2dieds_cache
      |> Cachex.stream!(),
      state
    }
  end

  @impl GenServer
  def handle_call({:count}, _from, state) do
    {
      :reply,
      :born2dieds_cache
      |> Cachex.size!(),
      state
    }
  end

  ################### handle_info ###################

  @impl GenServer
  def handle_info({@initializing_born2died_v1, born2died_init}, state) do
    :born2dieds_cache
    |> Cachex.put!(born2died_init.id, born2died_init)

    notify_born2dieds_updated({@initializing_born2died_v1, born2died_init})
    {:noreply, state}
  end


  @impl GenServer
  def handle_info({@born2died_initialized_v1, born2died_init}, state) do
    :born2dieds_cache
    |> Cachex.put!(born2died_init.id, born2died_init)

    notify_born2dieds_updated({@born2died_initialized_v1, born2died_init})
    {:noreply, state}
  end

  @impl GenServer
  def handle_info({@born2died_detached_v1, born2died_init}, state) do
    :born2dieds_cache
    |> Cachex.del!(born2died_init.id)

    notify_born2dieds_updated({@born2died_detached_v1, born2died_init})
    {:noreply, state}
  end


  @impl GenServer
  def handle_info({:born2died_state_changed, born2died_init}, state) do
    :born2dieds_cache
    |> Cachex.put!(born2died_init.id, born2died_init)

    notify_born2dieds_updated({@born2died_state_changed_v1, born2died_init})
    {:noreply, state}
  end


  ################### INTERNALS ###################
  defp notify_born2dieds_updated(cause),
    do:
      PubSub.broadcast!(
        Logatron.PubSub,
        @born2dieds_cache_updated_v1,
        cause
      )

  #################### PLUMBING ####################
  def child_spec(opts),
    do: %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :transient
    }

  def start_link(opts),
    do:
      GenServer.start_link(
        __MODULE__,
        opts,
        name: __MODULE__
      )
end
