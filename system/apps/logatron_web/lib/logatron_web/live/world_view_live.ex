defmodule LogatronWeb.WorldViewLive do
  use LogatronWeb, :live_view
  @moduledoc """
  LiveView module for the WorldView component.
  """

  def mount(_params, _session, socket) do
    {:ok, assign(socket, world: Logatron.World.get_world())}
  end


end
