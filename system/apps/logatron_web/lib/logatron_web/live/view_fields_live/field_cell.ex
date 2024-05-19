defmodule LogatronWeb.ViewFieldsLive.FieldCell do
  use LogatronWeb, :live_component
  @moduledoc """
    The FieldCellComponent is used to render a single cell in the FieldGrid
  """

 alias Cell.Init, as: CellInit

  def get_cell_id(current_user, field, col, row, field_no) do
    "#{current_user.id}-cell-#{field.id}"
  end

  @impl true
  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
    }
  end
end
