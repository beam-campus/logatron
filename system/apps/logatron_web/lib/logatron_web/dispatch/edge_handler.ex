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

    Logger.info("#{inspect(edge_init)}")

    ChannelWatcher.monitor(
      "edge:lobby",
      self(),
      {__MODULE__, :pub_edge_detached, [edge_init, socket]}
    )

    {:ok, socket}
  end

  def pub_edge_attached(edge_init_env, socket) do
    {:ok, edge_init} =  LogatronEdge.InitParams.from_map(edge_init_env["edge_init"])
    Logger.info("Attached edge: #{inspect(edge_init)}")
      PubSub.broadcast!(
        Logatron.PubSub,
        @edge_attached_v1,
        {@edge_attached_v1, edge_init}
      )
  end


  def pub_edge_detached(edge_init_env, socket) do
    {:ok, edge_init} =  LogatronEdge.InitParams.from_map(edge_init_env["edge_init"])
    Logger.info("Detached edge: #{inspect(edge_init)}")
    PubSub.broadcast!(
      Logatron.PubSub,
      @edge_detached_v1,
      {@edge_detached_v1, edge_init}
    )
  end


end
