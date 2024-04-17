defmodule LogatronWeb.EdgesLive.EdgesGrid do
  use LogatronWeb, :live_component

  alias Logatron.Edges.Server

  @impl true
  def update(assigns, socket) do
    {:ok, socket |> assign(assigns)}
  end






end
