defmodule LogatronWeb.ScapeLive.Show do
  use LogatronWeb, :live_view

  alias Logatron.Scapes

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:scape, Scapes.get_scape!(id))}
  end

  defp page_title(:show), do: "Show Scape"
  defp page_title(:edit), do: "Edit Scape"
end
