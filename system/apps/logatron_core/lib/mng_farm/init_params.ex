defmodule Logatron.MngFarm.InitParams do
  @moduledoc """
  Logatron.MngFarm.InitParams is the struct that identifies the state of a Farm.
  """
  use Ecto.Schema

  @id_prefix "mng_farm"

  alias Logatron.MngFarm.InitParams
  alias Logatron.Schema.{Id, Farm}

  import Ecto.Changeset

  require Logger

  @all_fields [
    :id,
    :edge_id,
    :region_id,
    :scape_id,
    :country,
    :farm_id,
    :max_row,
    :max_col,
    :max_depth,
    :farm
  ]

  @cast_fields [
    :id,
    :edge_id,
    :region_id,
    :scape_id,
    :farm_id,
    :max_row,
    :max_col,
    :max_depth,
    :country
  ]

  @required_fields [
    :id,
    :edge_id,
    :region_id,
    :scape_id,
    :country,
    :farm_id,
    :max_row,
    :max_col,
    :max_depth,
    :farm
  ]

  @derive {Jason.Encoder, only: @all_fields}
  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:edge_id, :string)
    field(:scape_id, :string)
    field(:region_id, :string)
    field(:country, :string)
    field(:farm_id, :string)
    field(:max_row, :integer)
    field(:max_col, :integer)
    field(:max_depth, :integer)
    embeds_one(:farm, Farm)
  end

  def from_region(region_init) do
    farm = Logatron.Schema.Farm.random()
    %Logatron.MngFarm.InitParams{
      id: Id.new(@id_prefix) |> Id.as_string(),
      edge_id: region_init.edge_id,
      region_id: region_init.id,
      scape_id: region_init.scape_id,
      country: region_init.name,
      farm_id: farm.id,
      max_col: farm.fields_def.x,
      max_row: farm.fields_def.y,
      max_depth: farm.fields_def.z,
      farm: farm
    }
  end

  def changeset(mng_farm, args)
      when is_map(args) do
    mng_farm
    |> cast(args, @cast_fields)
    |> cast_embed(:farm)
    |> validate_required(@required_fields)
  end

  def from_map(map) when is_map(map) do
    case(changeset(%InitParams{}, map)) do
      %{valid?: true} = changeset ->
        mng_farm_init =
          changeset
          |> Ecto.Changeset.apply_changes()

        {:ok, mng_farm_init}

      changeset ->
        {:error, changeset}
    end
  end
end
