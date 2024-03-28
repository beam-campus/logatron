defmodule LogatronWeb.ScapeLive.FormComponent do
  use LogatronWeb, :live_component

  alias Logatron.Scapes

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage scape records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="scape-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >

        <:actions>
          <.button phx-disable-with="Saving...">Save Scape</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{scape: scape} = assigns, socket) do
    changeset = Scapes.change_scape(scape)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"scape" => scape_params}, socket) do
    changeset =
      socket.assigns.scape
      |> Scapes.change_scape(scape_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"scape" => scape_params}, socket) do
    save_scape(socket, socket.assigns.action, scape_params)
  end

  defp save_scape(socket, :edit, scape_params) do
    case Scapes.update_scape(socket.assigns.scape, scape_params) do
      {:ok, scape} ->
        notify_parent({:saved, scape})

        {:noreply,
         socket
         |> put_flash(:info, "Scape updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_scape(socket, :new, scape_params) do
    case Scapes.create_scape(scape_params) do
      {:ok, scape} ->
        notify_parent({:saved, scape})

        {:noreply,
         socket
         |> put_flash(:info, "Scape created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
