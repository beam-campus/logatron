defmodule LogatronWeb.ScapeLive.Index do
  use LogatronWeb, :live_view

  alias Logatron.Scapes
  alias Logatron.Scapes.Scape

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :scapes, Scapes.list_scapes())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Scape")
    |> assign(:scape, Scapes.get_scape!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Scape")
    |> assign(:scape, %Scape{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Scapes")
    |> assign(:scape, nil)
  end

  @impl true
  def handle_info({LogatronWeb.ScapeLive.FormComponent, {:saved, scape}}, socket) do
    {:noreply, stream_insert(socket, :scapes, scape)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    scape = Scapes.get_scape!(id)
    {:ok, _} = Scapes.delete_scape(scape)

    {:noreply, stream_delete(socket, :scapes, scape)}
  end
end
