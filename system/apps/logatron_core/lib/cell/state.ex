defmodule Cell.State do
  @moduledoc """
  Cell.State is the struct that identifies the state of a Cell.
  """
  use Ecto.Schema

  alias Cell.State, as: CellState
  alias Born2Died.State, as: LifeState
  alias Field.Effect, as: Effect
  alias Cell.Init, as: CellInit

  import Ecto.Changeset

  require Logger

  @all_fields [
    :id,
    :meta,
    :occupants,
    :effects
  ]

  @flat_fields [
    :id
  ]


  @primary_key false
  @derive {Jason.Encoder, only: @all_fields}
  embedded_schema do
    field(:id, :string)
    embeds_one(:meta, CellInit)
    embeds_many(:occupants, LifeState)
    embeds_many(:effects, Effect)
  end

  def from_cell_init(%CellInit{} = cell_init) do
    %CellState{
      id: cell_init.id,
      meta: cell_init,
      occupants: [],
      effects: []
    }
  end


  def changeset(cell, args) when is_map(args) do
    cell
    |> cast(args, @flat_fields)
    |> validate_required(@all_fields)
  end
end
