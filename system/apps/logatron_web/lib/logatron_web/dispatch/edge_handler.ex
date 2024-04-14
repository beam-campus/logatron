defmodule LogatronWeb.Dispatch.EdgeHandler do
  @moduledoc """
  The EdgeHandler is used to broadcast messages to all clients
  """

  require Logger

  alias LogatronWeb.Dispatch.ChannelWatcher
  alias Phoenix.PubSub


  @edge_detached_v1 LogatronCore.Facts.edge_detached_v1()
  @edge_attached_v1 LogatronCore.Facts.edge_attached_v1()

  def handle_join("edge:lobby", edge_init, socket) do
    send(self(), :after_join)

    ChannelWatcher.monitor(
      "edge:lobby",
      self(),
      {__MODULE__, :pub_edge_detached, [edge_init, socket]}
    )

    {:ok, socket}
  end

  def pub_edge_attached(payload, _socket) do
    {:ok, edge_init} = LogatronEdge.InitParams.from_map(payload["edge_init"])

    Logatron.Edges.Cache.save(edge_init)

    PubSub.broadcast!(
      Logatron.PubSub,
      @edge_attached_v1,
      {@edge_attached_v1, edge_init}
    )
  end

  def pub_edge_detached(payload, _socket) do
    {:ok, edge_init} = LogatronEdge.InitParams.from_map(payload["edge_init"])

    Logatron.Edges.Cache.delete_by_id(edge_init.id)
    :scapes |> Cachex.del!({edge_init.id, edge_init.scape_id})

    PubSub.broadcast!(
      Logatron.PubSub,
      @edge_detached_v1,
      {@edge_detached_v1, edge_init}
    )
  end
end
