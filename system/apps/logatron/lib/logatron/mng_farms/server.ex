defmodule Logatron.MngFarms.Server do
  use GenServer

  @moduledoc """
  The server for the farms Cache.
  """

  require Logger
  require Cachex

  alias Phoenix.PubSub
  alias LogatronCore.Facts

  @initializing_farm_v1 Facts.initializing_farm_v1()
  @farm_detached_v1 Facts.farm_detached_v1()
  @farms_cache_updated_v1 Facts.farms_cache_updated_v1()


  ########### PUBLIC API ##########

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

  ############ CALLBACKS ############


  ################ handle_call ###########
  @impl GenServer
  def handle_call({:get_all}, _from, state) do
    {
      :reply,
      :farms_cache
      |> Cachex.stream!()
      |> Enum.map(fn {:entry, _key, _nil, _internal_id, mng_farm_init} -> mng_farm_init end),
      state
    }
  end

  @impl GenServer
  def handle_call({:get_stream}, _from, state) do
    {
      :reply,
      :farms_cache
      |> Cachex.stream!(),
      state
    }
  end
  ############# handle_info ##############
  @impl GenServer
  def handle_info({@initializing_farm_v1, mng_farm_init}, state) do
    key =
      {
        mng_farm_init.edge_id,
        mng_farm_init.scape_id,
        mng_farm_init.region_id,
        mng_farm_init.id
      }

    :farms_cache
    |> Cachex.put!(key, mng_farm_init)

    notify_farms_updated({@initializing_farm_v1, mng_farm_init})

    {:noreply, state}
  end


  @impl GenServer
  def handle_info({@farm_detached_v1, mng_farm_init}, state) do
    key =
      {
        mng_farm_init.edge_id,
        mng_farm_init.scape_id,
        mng_farm_init.region_id,
        mng_farm_init.id
      }
      
    :farms_cache
    |> Cachex.del!(key)

    notify_farms_updated({@farm_detached_v1, mng_farm_init})

    {:noreply, state}
  end

  @impl GenServer
  def init(opts) do
    Logger.info("Starting farms cache")

    :farms_cache
    |> Cachex.start()

    PubSub.subscribe(Logatron.PubSub, @initializing_farm_v1)

    {:ok, opts}
  end

  ############ INTERNALS ############
  defp notify_farms_updated(cause),
    do:
      PubSub.broadcast(
        Logatron.PubSub,
        @farms_cache_updated_v1,
        cause
      )

  #################### PLUMBING #############
  def child_spec(opts),
    do: %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      restart: :permanent
    }

  def start_link(opts),
    do:
      GenServer.start_link(
        __MODULE__,
        opts,
        name: __MODULE__
      )
end
