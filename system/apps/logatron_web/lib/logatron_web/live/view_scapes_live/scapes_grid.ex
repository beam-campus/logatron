defmodule LogatronWeb.ViewScapesLive.ScapesGrid do
  use LogatronWeb, :live_component

  @moduledoc """
  The live component for the scapes grid.
  """

  alias Phoenix.PubSub

  alias Logatron.Scapes.{
    Scape,
    Region,
    Farm,
    Animal
  }

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="h-full border rounded m-5 px-4 py-3 text-white">
      <h1 class="text-2xl font-bold">Scapes</h1>
      <div class="grid grid-cols-1 gap-4">
        <%= for {:entry, _,_,_, scape} <- @scapes do %>
          <div class="border rounded p-3">
            <h2 class="text-xl font-bold">NAME: <%= scape.name %></h2>
            <p>fed by agent: <%= scape.edge_id %></p>
            <p>selects from: <%= scape.select_from %></p>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
