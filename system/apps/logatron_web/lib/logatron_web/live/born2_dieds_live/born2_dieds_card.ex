defmodule LogatronWeb.Born2DiedsLive.Born2DiedsCard do
  use LogatronWeb, :live_component

  @impl true
  def mount(assigns, socket) do
    {:ok, socket |> assign(assigns)}
  end

  @impl true
  def render(%{} = assigns) do
    ~H"""
    <div class="flex flex-col px-4 py-4 font-mono text-sm border rounded">
        <div class="py-1">
          <h2 class="font-bold text-ltTurquoise-light"><%= @state.life.name %></h2>
          <div class="flex flex-col">
              <div class="flex flex-col px-1 text-white" >
                <p>(<%= @state.pos.x %>, <%= @state.pos.y %>)</p>
                <p>age:  <%= @state.vitals.age  %></p>
                <p>health: <%= @state.vitals.health %></p>
              </div>
          </div>
        </div>
    </div>
    """
  end



end
