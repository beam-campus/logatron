defmodule Cells.Service do

  @moduledoc """
  The service for the Cells subsystem.
  """

  alias Lives.Service, as: Lives
  alias Cell.State, as: CellState
  alias Born2Died.State, as: LifeState

  def get_cell_states(nil), do: []

  def get_cell_states(mng_farm_id) do
    Lives.get_by_mng_farm_id(mng_farm_id)
    |> Enum.map(fn  %LifeState{} = live ->
      %CellState {
        col: live.pos.x,
        row: live.pos.y,
        depth: live.pos.z,
        content: calculate_content(live),
        class: calculate_class(live),
        edge_id: live.edge_id,
        scape_id: live.scape_id,
        region_id: live.region_id,
        mng_farm_id: live.mng_farm_id,
        occupants: [],
        effects: []
      }
    end)
  end


  def calculate_content(%LifeState{} = _live) do
    "x"
  end

  def calculate_class(%LifeState{} = _live) do
    "cell"
  end

end
