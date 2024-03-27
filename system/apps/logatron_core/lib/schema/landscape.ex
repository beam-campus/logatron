defmodule Logatron.Schema.Landscape do
  use Ecto.Schema

  @moduledoc """
  Logatron.Schema.Landscape contains the Ecto schema for the landscape.
  """

  import Ecto.Changeset

  alias Logatron.Schema.Edge
  alias Logatron.Schema.Landscape
  alias Logatron.Schema.Id
  alias Logatron.Schema.Region

  def id_prefix(), do: "landscape"

  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:name, :string)
    embeds_many(:sourced_by, Edge)
    embeds_many(:regions, Region)
  end

  def random_id() do
    Id.new(id_prefix())
    |> Id.as_string()
  end

  def changeset(landscape, args)
      when is_map(args) do
    landscape
    |> cast(args, [:name])
    |> cast_embed(:regions,
      with: &Region.changeset/2
    )
    |> validate_required([
      :name
    ])
  end

  @doc """
  Landscape.new(args) requires an input map that contains:
  1. a name for the landscape
  2. regions: a list of regions for the landscape
  """
  def new(args) when is_map(args) do
    new_id =
      Id.new(id_prefix())
      |> Id.as_string()

    case changeset(%Landscape{}, args) do
      %{valid?: true} = changeset ->
        landscape =
          changeset
          |> apply_changes()
          |> Map.put(:id, new_id)

        {:ok, landscape}

      changeset ->
        {:error, changeset}
    end
  end
end
