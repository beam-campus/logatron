defmodule LogatronWeb.Dispatch.ScapeHandler do
  @moduledoc """
  The ScapeHandler is used to broadcast messages to all clients
  """

  alias LogatronCore.Facts
  alias LogatronEdge.Scape.InitParams

  require Logger

  @scape_initializing_v1 Facts.initializing_scape_v1()
  @scape_initialized_v1 Facts.scape_initialized_v1()
  @scape_detached_v1 Facts.scape_detached_v1()


  def pub_initializing_scape_v1(scape_init_env, socket) do
    {:ok, scape_init} = InitParams.from_map(scape_init_env["scape_init"])

    Cachex.set!(:scapes, {scape_init.edge_id, scape_init.id}, scape_init)

    Phoenix.PubSub.broadcast(
      Logatron.PubSub,
      @scape_initializing_v1,
      {@scape_initializing_v1, scape_init}
    )

    {:noreply, socket}
  end

  def pub_scape_initialized_v1(scape_init_env, socket) do
    {:ok, scape_init} = InitParams.from_map(scape_init_env["scape_init"])

    Phoenix.PubSub.broadcast(
      Logatron.PubSub,
      @scape_initialized_v1,
      {@scape_initialized_v1, scape_init}
    )

    {:noreply, socket}
  end


  def pub_scape_detached_v1(scape_init_env, socket) do
    {:ok, scape_init} = InitParams.from_map(scape_init_env["scape_init"])



    Phoenix.PubSub.broadcast(
      Logatron.PubSub,
      @scape_detached_v1,
      {@scape_detached_v1, scape_init}
    )

    {:noreply, socket}
  end


end
