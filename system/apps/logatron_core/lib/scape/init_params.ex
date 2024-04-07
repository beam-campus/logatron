defmodule LogatronEdge.Scape.InitParams do
  @moduledoc """
  Scape.InitParams is a struct that holds the parameters for initializing a scape.
  """
  use Ecto.Schema

  import Ecto.Changeset
  require MnemonicSlugs

  alias LogatronEdge.Scape.InitParams

  @all_fields [
    :id,
    :name,
    :edge_id,
    :nbr_of_countries,
    :min_area,
    :min_people
  ]

  @required_fields [
    :id,
    :name,
    :edge_id,
    :nbr_of_countries,
    :min_area,
    :min_people,
    :select_from
  ]

  @derive {Jason.Encoder, only: @all_fields}
  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:name, :string)
    field(:edge_id, :string)
    field(:nbr_of_countries, :integer)
    field(:min_area, :integer)
    field(:min_people, :integer)
    embeds_many(:select_from, :string)
  end

  def changeset(scape, args)
      when is_map(args) do
    scape
    |> cast(args, @all_fields)
    |> cast_embed(:select_from)
    |> validate_required(@required_fields)
  end

  def default(edge_id),
    do: europe(edge_id)

  def europe(edge_id),
    do: %InitParams{
      id: "europe",
      name: "Europe",
      edge_id: edge_id,
      nbr_of_countries: Logatron.Limits.max_regions(),
      min_area: 30_000,
      min_people: 10_000_000,
      select_from: ["Europe"]
    }

  def asia(edge_id),
    do: %InitParams{
      id: "asia",
      name: "Asia",
      edge_id: edge_id,
      nbr_of_countries: Logatron.Limits.max_regions(),
      min_area: 50_000,
      min_people: 40_000_000,
      select_from: ["Asia"]
    }

  def from_environment(edge_id) do
    select_from =
      System.get_env("LOGATRON_SELECT_FROM")
      |> String.split(",")

    %InitParams{
      id: System.get_env("LOGATRON_SCAPE_ID"),
      name: System.get_env("LOGATRON_SCAPE_NAME"),
      edge_id: edge_id,
      nbr_of_countries: System.get_env("LOGATRON_NBR_OF_COUNTRIES"),
      min_area: System.get_env("LOGATRON_MIN_AREA"),
      min_people: System.get_env("LOGATRON_MIN_PEOPLE"),
      select_from: select_from
    }
  end

  def from_config(edge_id) do
    %InitParams{
      id: Application.get_env(:logatron_edge, :scape_id),
      name: Application.get_env(:logatron_edge, :scape_name),
      edge_id: edge_id,
      nbr_of_countries: Application.get_env(:logatron_edge, :nbr_of_countries),
      min_area: Application.get_env(:logatron_edge, :min_area),
      min_people: Application.get_env(:logatron_edge, :min_people),
      select_from: Application.get_env(:logatron_edge, :select_from)
    }
  end

  def from_file(edge_id) do
    {:ok, file} = File.read("scape_init_params.json")
    {:ok, json} = Jason.decode(file)

    %InitParams{
      id: Map.get(json, "id"),
      name: Map.get(json, "name"),
      edge_id: edge_id,
      nbr_of_countries: Map.get(json, "nbr_of_countries"),
      min_area: Map.get(json, "min_area"),
      min_people: Map.get(json, "min_people"),
      select_from: Map.get(json, "select_from")
    }
  end

  def from_random(edge_id) do
    %InitParams{
      id: Logatron.Schema.Scape.random_id(),
      name: MnemonicSlugs.generate_slug(2),
      edge_id: edge_id,
      nbr_of_countries: Logatron.Limits.max_regions(),
      min_area: 30_000,
      min_people: 10_000_000,
      select_from: ["Europe"]
    }
  end

  def from_map(map) when is_map(map) do
    case(changeset(%InitParams{}, map)) do
      %{valid?: true} = changeset ->
        scape_init =
          changeset
          |> apply_changes()

        {:ok, scape_init}

      changeset ->
        {:error, changeset}
    end
  end
end
