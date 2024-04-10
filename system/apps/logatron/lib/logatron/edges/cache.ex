defmodule Logatron.Edges.Cache do
  @moduledoc """
  The Cache module is used to store and retrieve data from the Edges ETS cache.
  """

  # alias ETS.KeyValueSet

  require Logger

  def count() do
    if edges_table_exists?() do
      :ets.info(:edges, :size)
    else
      0
    end
  end

  def edges_table_exists?() do
    case :ets.all()
         |> Enum.find(fn table -> table == :edges end) do
      nil -> false
      _ -> true
    end
  end

  def create_table() do
    res =
      case edges_table_exists?() do
        true ->
          :ok

        false ->
          :ets.new(
            :edges,
            [
              :named_table,
              :set,
              :public
            ]
          )

          :ok
      end

    res
  end

  def save(edge_init) do
    :ok = create_table()
    edge_kv = {edge_init.id, edge_init}

    case :ets.lookup(:edges, edge_kv) do
      [] ->
        :ets.insert_new(:edges, edge_kv)

      _ ->
        :ets.insert(:edges, edge_kv)
    end

    :ok
  end

  def get_raw() do
    if edges_table_exists?() do
      :ets.tab2list(:edges)
    else
      []
    end
  end

  def get_all() do
    if edges_table_exists?() do
      :ets.tab2list(:edges)
      |> Enum.map(&elem(&1, 1))
    else
      []
    end
  end

  def get_by_id(id) do
    if edges_table_exists?() do
      :ets.lookup(:edges, id)
      |> Enum.map(&elem(&1, 1))
    else
      []
    end
  end

  def delete_by_id(id) do
    if edges_table_exists?() do
      Logger.error("\n\n\n\n Deleting edge with id: #{id} \n\n\n\n")
      :ets.delete(:edges, id)
    end
  end

  def get_raw_by_id(edge_id) do
    if edges_table_exists?() do
      :ets.tab2list(:edges)
      |> Enum.filter(fn {_, edge} -> edge.edge_id == edge_id end)
    else
      []
    end
  end

  def delete_raw_by_id(edge_id) do
    if edges_table_exists?() do
      res = get_raw_by_id(edge_id)
      :ets.delete(:edges, res)
    end
  end

  def delete_all() do
    # :ets.delete_all_objects(:edges)
    KeyValueSet.delete(:edges)
  end
end
