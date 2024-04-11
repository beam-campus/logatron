# Credits: Special thanks to @cmo and @al2o3cr for the help on this one.


defmodule Logatron.Edges.Cache do
  use GenServer

  @moduledoc """
  The Cache module is used to store and retrieve data from the Edges ETS cache.
  """

  require Logger

  def count(),
    do:
      GenServer.call(
        __MODULE__,
        :count
      )

  def delete_by_id(id),
    do:
      GenServer.call(
        __MODULE__,
        {:delete_by_id, id}
      )

  def save(edge_init),
    do:
      GenServer.cast(
        __MODULE__,
        {:save, edge_init}
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

  def delete_all(),
    do:
      GenServer.cast(
        __MODULE__,
        :delete_all
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
  def handle_call({:delete_by_id, id}, _from, state),
    do: {:reply, :ets.delete(:edges, id), state}

  @impl GenServer
  def handle_call({:get_by_id, id}, _from, state),
    do:
      {:reply,
       :ets.lookup(:edges, id)
       |> Enum.map(&elem(&1, 1)), state}

  @impl GenServer
  def handle_cast({:save, edge_init}, state) do
    res = :ets.insert(:edges, {edge_init.id, edge_init})
    Logger.error("Tried to Save: \n\n #{inspect(edge_init)}, \n\n result= #{inspect(res)}")
    {:noreply, state}
  end

  @impl GenServer
  def handle_cast(:delete_all, state)  do
    res = :ets.delete_all_objects(:edges)
    Logger.error("Tried to Delete All: \n\n result= #{inspect(res)}")
    {:noreply, state}
  end

  @impl GenServer
  def init(_args) do
    :ets.new(:edges, [:named_table, :set, :public])
    {:ok, []}
  end

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
