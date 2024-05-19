defmodule LogatronWeb.ViewFieldsLive.FieldsListView do
  use LogatronWeb, :live_component

  @moduledoc """
  The live component for the fields list view.
  """

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
  end
end
