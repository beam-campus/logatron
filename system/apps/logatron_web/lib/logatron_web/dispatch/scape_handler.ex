defmodule LogatronWeb.Dispatch.ScapeHandler do
  @moduledoc """
  The ScapeHandler is used to broadcast messages to all clients
  """

  alias LogatronCore.Facts
  alias LogatronEdge.Scape.InitParams


  require Logger

  @scape_attached_v1 Facts.scape_attached_v1()
  @scape_initializing_v1 Facts.initializing_scape_v1()
  @scape_initialized_v1 Facts.scape_initialized_v1()

  def pub_attach_scape_v1(scape_init, socket) do
    Logger.debug("#{inspect(scape_init)}")

    {:ok, scape} = Scape.from_map(scape_init)

    Phoenix.PubSub.broadcast(
      Logatron.PubSub,
      @scape_attached_v1,
      {@scape_attached_v1, scape}
    )

    {:ok, scape}
  end

  def pub_initializing_scape_v1(scape_init_env, socket) do

    Logger.debug("#{inspect(scape_init_env)}")

    {:ok, scape_init} =  InitParams.from_map(scape_init_env)
    # {:ok, scape_init} = Scape.add_source(scape_init, scape_init_env["edge_id"])

    Phoenix.PubSub.broadcast(
      Logatron.PubSub,
      @scape_initializing_v1,
      {@scape_initializing_v1, scape_init}
    )

    {:noreply, socket}
  end


  def pub_scape_initialized_v1(scape_init, socket) do
    Logger.debug("#{inspect(scape_init)}")

    Phoenix.PubSub.broadcast(
      Logatron.PubSub,
      @scape_initialized_v1,
      {@scape_initialized_v1, scape_init}
    )

    {:noreply, socket}
  end


end
