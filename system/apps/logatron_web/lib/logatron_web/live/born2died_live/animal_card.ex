defmodule LogatronWeb.Born2DiedLive.AnimalCard do
  use LogatronWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def render(%{} = assigns) do
    ~H"""
    <div class="flex flex-col text-ltTurquoise-light w-screen py-4 font-mono px-10">
      <%= for born2died <- @born2died do %>
        <div class="py-1">
          <h2><%= born2died.name %></h2>
          <div class="flex flex-col">
            <%= for region <- born2died.regions do %>
              <div class="flex flex-row gap-3 px-4 ">
                <h3><%= region.name %></h3>
                <p><%= region.description %></p>
                <p><%= region.latitude %>, <%= region.longitude %></p>
              </div>

            <% end %>
          </div>
        </div>
      <% end %>
    </div>
    """
  end



end
