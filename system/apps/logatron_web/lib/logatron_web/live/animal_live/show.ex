defmodule LogatronWeb.AnimalLive.Show do
  use LogatronWeb, :live_view

  alias Logatron.Born2Dieds

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:animal, Born2Dieds.get_animal!(id))}
  end

  defp page_title(:show), do: "Show Animal"
  defp page_title(:edit), do: "Edit Animal"
end
