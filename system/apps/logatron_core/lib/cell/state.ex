defmodule Cell.State do
  @moduledoc """
  Cell.State is the struct that identifies the state of a Cell.
  """
  use Ecto.Schema

  alias Born2Died.State, as: LifeState
  alias Field.Effect, as: Effect


  import Ecto.Changeset

  require Logger

  @all_fields [
    :col,
    :row,
    :depth,
    :content,
    :class,
    :edge_id,
    :scape_id,
    :region_id,
    :mng_farm_id,
    :occupants,
    :effects
  ]





  @flat_fields [
    :id
  ]


  @primary_key false
  @derive {Jason.Encoder, only: @all_fields}
  embedded_schema do
    field(:col, :integer)
    field(:row, :integer)
    field(:depth, :integer)
    field(:content, :string)
    field(:class, :string)
    field(:edge_id, :string)
    field(:scape_id, :string)
    field(:region_id, :string)
    field(:mng_farm_id, :string)
    embeds_many(:occupants, LifeState)
    embeds_many(:effects, Effect)
  end


  def changeset(cell, args) when is_map(args) do
    cell
    |> cast(args, @flat_fields)
    |> validate_required(@all_fields)
  end
end
