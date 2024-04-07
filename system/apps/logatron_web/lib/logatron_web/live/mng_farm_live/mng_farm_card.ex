defmodule LogatronWeb.MngFarmLive.MngFarmCard do
  use LogatronWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    {:noreply, assigns}
  end


  @impl true
  def render(%{} = assigns) do
    ~H"""
    <div class="flex flex-col text-ltTurquoise-light w-screen py-4 font-mono px-10">
      Farm
    </div>
    """
  end

end
