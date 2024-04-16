# Credits: Special thanks to @cmo and @al2o3cr for the help on this one.

defmodule Logatron.Edges.Cache do
  use GenServer

  @moduledoc """
  The Cache module is used to store and retrieve data from the Edges ETS cache.
  """

  alias LogatronCore.Facts
  alias Phoenix.PubSub

  require Logger

  @edges_cache_updated_v1 Facts.edges_cache_updated_v1()
  @edge_attached_v1 Facts.edge_attached_v1()
  @edge_detached_v1 Facts.edge_detached_v1()

  def count(),
    do:
      GenServer.call(
        __MODULE__,
        :count
      )


  def get_all(),
    do:
      GenServer.call(
        __MODULE__,
        :get_all
      )

  def get_by_id(id),
    do:
      GenServer.call(
        __MODULE__,
        {:get_by_id, id}
      )


  ############## CALLBACKS #########
  @impl GenServer
  def handle_call(:count, _from, state),
    do: {:reply, :ets.info(:edges, :size), state}

  @impl GenServer
  def handle_call(:get_all, _from, state),
    do:
      {:reply,
       :ets.tab2list(:edges)
       |> Enum.map(&elem(&1, 1)), state}


  @impl GenServer
  def handle_call({:get_by_id, id}, _from, state),
    do:
      {:reply,
       :ets.lookup(:edges, id)
       |> Enum.map(&elem(&1, 1)), state}

  ################### handle_info ###################
  @impl GenServer
  def handle_info({@edge_attached_v1, edge_init}, state) do
    :ets.insert(:edges, {edge_init.id, edge_init})
    notify_edges_updated({@edge_attached_v1, edge_init})
    {:noreply, state}
  end

  @impl GenServer
  def handle_info({@edge_detached_v1, edge_init}, state) do
    :ets.delete(:edges, edge_init.id)
    notify_edges_updated({@edge_detached_v1, edge_init})
    {:noreply, state}
  end

  @impl GenServer
  def init(args \\ []) do
    :ets.new(:edges, [:named_table, :set, :public])
    PubSub.subscribe(Logatron.PubSub, @edge_attached_v1)
    PubSub.subscribe(Logatron.PubSub, @edge_detached_v1)
    {:ok, args}
  end

  ############ INTERNALS ########
  defp notify_edges_updated(cause),
    do:
      PubSub.broadcast!(
        Logatron.PubSub,
        @edges_cache_updated_v1,
        cause
      )

  ########### PLUMBING ##########

  def child_spec(),
    do: %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :worker,
      restart: :permanent
    }

  def start_link(_args),
    do:
      GenServer.start_link(
        __MODULE__,
        nil,
        name: __MODULE__
      )
end
