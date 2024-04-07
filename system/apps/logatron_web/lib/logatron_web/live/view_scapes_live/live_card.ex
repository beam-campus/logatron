defmodule LogatronWeb.ViewScapesLive.LiveCard do
  use LogatronWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-row">

    </div>
    """
  end

  @impl true
  def update(%{life: life} = assigns, socket) do
    {:ok, socket |> assign(assigns)}
  end



  
end
