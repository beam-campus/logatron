defmodule Logatron.MngFarm.InitParams do
  @moduledoc """
  Logatron.MngFarm.InitParams is the struct that identifies the state of a Farm.
  """
  use Ecto.Schema

  @id_prefix "mng_farm"

  alias Logatron.MngFarm.InitParams
  alias Logatron.Schema.{Id, Farm}
  import Ecto.Changeset

  @all_fields [
    :id,
    :edge_id,
    :region_id,
    :scape_id,
    :nbr_of_lives,
    :farm
  ]

  @cast_fields [
    :id,
    :edge_id,
    :region_id,
    :scape_id,
    :nbr_of_lives
  ]

  @required_fields [
    :id,
    :edge_id,
    :region_id,
    :scape_id,
    :nbr_of_lives,
    :farm
  ]

  @derive {Jason.Encoder, only: @all_fields}
  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:edge_id, :string)
    field(:scape_id, :string)
    field(:region_id, :string)
    field(:nbr_of_lives, :integer)
    embeds_one(:farm, Farm)
  end

  def default,
    do: %Logatron.MngFarm.InitParams{
      id: "mng_farm-0000-0000-0000-000000000000",
      nbr_of_lives: 10
    }

  def from_farm(farm, region_init),
    do: %Logatron.MngFarm.InitParams{
      id: Id.new(@id_prefix) |> Id.as_string(),
      edge_id: region_init.edge_id,
      region_id: region_init.id,
      scape_id: region_init.scape_id,
      nbr_of_lives: Logatron.Limits.random_nbr_lives(),
      farm: farm
    }

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
