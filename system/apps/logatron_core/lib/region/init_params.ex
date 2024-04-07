defmodule Logatron.Region.InitParams do
  @moduledoc """
  Logatron.Region.InitParams is the struct that identifies the state of a Region.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Logatron.Region.InitParams

  @all_fields [
    :id,
    :edge_id,
    :scape_id,
    :name,
    :nbr_of_farms
  ]

  @required_fields [
    :id,
    :edge_id,
    :scape_id,
    :name,
    :nbr_of_farms
  ]

  @derive {Jason.Encoder, only: @all_fields}
  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:edge_id, :string)
    field(:scape_id, :string)
    field(:name, :string)
    field(:nbr_of_farms, :integer)
  end

  def random(edge_id, scape_id, id, name) do
    %Logatron.Region.InitParams{
      edge_id: edge_id,
      scape_id: scape_id,
      id: id,
      name: name,
      nbr_of_farms: :rand.uniform(5)
    }
  end

  def default(edge_id, scape_id),
    do: %Logatron.Region.InitParams{
      edge_id: edge_id,
      scape_id: scape_id,
      id: "belgium",
      name: "Belgium",
      nbr_of_farms: 3
    }

  def from_map(map) when is_map(map) do
    case(changeset(%InitParams{}, map)) do
      %{valid?: true} = changeset ->
        region_init =
          changeset
          |> apply_changes()

        {:ok, region_init}

      changeset ->
        {:error, changeset}
    end
  end

  def changeset(region, args)
      when is_map(args),
      do:
        region
        |> cast(args, @all_fields)
        |> validate_required(@required_fields)
end
