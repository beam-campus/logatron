defmodule LogatronWeb.PlayingFieldLive.PlayingFieldGrid do
  use LogatronWeb, :live_component



  def get_cell_color(grid, coords) do
    case Map.get(grid, coords) do
      :empty -> "white"
      :occupied -> "green"
      _ -> "red"
    end
  end

  def get_cell_text(grid, coords) do
    case Map.get(grid, coords) do
      :empty -> ""
      :occupied -> "X"
      _ -> "?"
    end
  end

  def get_cell_class(grid, coords) do
    case Map.get(grid, coords) do
      :empty -> "empty"
      :occupied -> "occupied"
      _ -> "unknown"
    end
  end

  def get_cell_id(coords) do
    "cell-#{elem(coords, 0)}-#{elem(coords, 1)}"
  end

  def get_cell_coords(cell_id) do
    [_, x, y] = String.split(cell_id, "-")
    {String.to_integer(x), String.to_integer(y)}
  end

  def get_cell_coords_from_event(event) do
    get_cell_coords(event.target.id)
  end

  def get_cell_id_from_event(event) do
    event.target.id
  end

  def get_cell_coords_from_drag(event) do
    get_cell_coords(event.target.id)
  end

  def get_cell_id_from_drag(event) do
    event.target.id
  end

  def get_cell_coords_from_drop(event) do
    get_cell_coords(event.target.id)
  end

  def get_cell_id_from_drop(event) do
    event.target.id
  end

  def get_cell_coords_from_dragover(event) do
    get_cell_coords(event.target.id)
  end

  def get_cell_id_from_dragover(event) do
    event.target.id
  end

  def get_cell_coords_from_dragenter(event) do
    get_cell_coords(event.target.id)
  end

  def get_cell_id_from_dragenter(event) do
    event.target.id
  end

  def get_cell_coords_from_dragleave(event) do
    get_cell_coords(event.target.id)
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
