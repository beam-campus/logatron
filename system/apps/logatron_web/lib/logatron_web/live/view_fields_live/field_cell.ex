defmodule LogatronWeb.ViewFieldsLive.FieldCell do
  use LogatronWeb, :live_component

  @moduledoc """
    The FieldCellComponent is used to render a single cell in the FieldGrid
  """

  alias Cell.State, as: CellState

  require Logger

  # The functional component that renders the cell
  def cell_content(assigns),
    do: ~H"""
    <div class="px-1 text-xl text-red-500 bg-blue-500 justify" >
    <%= @content %>
    </div>
    """

  def get_cell_state(cell_states, col, row) do
    cell_state =
      cell_states
      |> Enum.find(fn %CellState{} = cell_state ->
        cell_state.col == col and cell_state.row == row
      end)

    case cell_state do
      nil ->
        %CellState{
          col: col,
          row: row,
          content: " ",
          class: "w-5 h-5"
        }

      _ ->
        cell_state
    end
  end

  @impl true
  def update(assigns, socket) do
    cell_state = get_cell_state(assigns.cell_states, assigns.col, assigns.row)
    content = cell_state.content

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:cell_state, cell_state)
      |> assign(:content, content)
      |> assign(:class, cell_state.class)
    }
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class={@class}>
    <.cell_content content={@content}/>
    </div>
    """
  end
end
