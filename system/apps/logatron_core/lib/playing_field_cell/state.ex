defmodule PlayingFieldCell.State do

  @moduledoc """
  PlayingFieldCell.State is the struct that identifies the state of a PlayingFieldCell.
  """
  use Ecto.Schema

  @id_prefix "playing_field_cell"

  alias Logatron.Born2Died
  alias PlayingFieldCell.State, as: CellState
  alias PlayingFieldCell.InitParams, as: CellInit
  alias Born2Died.State, as: LifeState

  import Ecto.Changeset

  require Logger

  @all_fields [
    :id,
    :meta,
    :occupants,
    :actors
  ]

  @primary_key false
  embedded_schema do
    field(:id, :string)
    embeds_one(:meta, CellInit)
    embeds_many(:occupants, LifeState )
    field(:actors, {:array, :map})
  end








end
