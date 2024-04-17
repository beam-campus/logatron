defmodule LogatronWeb.Dispatch.EdgeHandler do

  @moduledoc """
  The EdgeHandler is used to broadcast messages to all clients
  """

  alias LogatronCore.Facts
  alias Phoenix.PubSub

  @edge_detached_v1 Facts.edge_detached_v1()
  @edge_attached_v1 Facts.edge_attached_v1()

  ################ CALLBACKS ################

  def pub_edge_detached(payload) do
    {:ok, edge_init} = LogatronEdge.InitParams.from_map(payload["edge_init"])

    PubSub.broadcast!(
      Logatron.PubSub,
      @edge_detached_v1,
      {@edge_detached_v1, edge_init}
    )
  end

  def pub_edge_attached(payload) do
    {:ok, edge_init} = LogatronEdge.InitParams.from_map(payload["edge_init"])

    PubSub.broadcast!(
      Logatron.PubSub,
      @edge_attached_v1,
      {@edge_attached_v1, edge_init}
    )
  end
end
