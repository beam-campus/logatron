defmodule Logatron.Schema.Farm do
  @moduledoc """
  Logatron.Schema.Farm is a schema for a farm.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Logatron.Schema.Farm
  alias Logatron.Schema.Id

  @farm_names [
    "Aaron",
    "Abira",
    "Accunti",
    "Adrino",
    "Aldono",
    "Balear",
    "Bandana",
    "Binodo",
    "Castella",
    "Charles",
    "Contina",
    "Cupodo",
    "Dinga",
    "Donga",
    "Datil",
    "Eanti",
    "Elondo",
    "Fildina",
    "Fungus",
    "Fillo",
    "Gerdin",
    "Golles",
    "Hando",
    "Hundi",
    "Impala",
    "Inco",
    "Ilteri",
    "Julo",
    "Jandi",
    "Kold",
    "Kantra",
    "Kilo",
    "Lodi",
    "Lanka",
    "Mista",
    "Nokila",
    "Omki",
    "Pidso",
    "Quenke",
    "Rondi",
    "Solo",
    "Salto",
    "Tandy",
    "Tonko",
    "Telda",
    "Umpo",
    "Uldin",
    "Verto",
    "Wondi",
    "Xunda",
    "Yzum",
    "Zompi"
  ]

  @farm_colors [
    "White",
    "Black",
    "Green",
    "Red",
    "Orange",
    "Yellow",
    "Blue",
    "Indigo",
    "Pink",
    "Brown",
    "Grey",
    "Purple",
    "Cyan",
    "Turquoise"
  ]

  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:name, :string)
    field(:nbr_of_robots, :integer)
    field(:nbr_of_lives, :integer)
  end

  defp id_prefix,
    do: "farm"

  def changeset(farm, args) do
    farm
    |> cast(
      args,
      [
        :name,
        :nbr_of_robots,
        :nbr_of_lives
      ]
    )
    |> validate_required([
      :name,
      :nbr_of_robots,
      :nbr_of_lives
    ])
  end

  def new(attrs) do
    case changeset(%Farm{}, attrs) do
      %{valid?: true} = changeset ->
        id =
          Id.new(id_prefix())
          |> Id.as_string()

        farm =
          changeset
          |> Ecto.Changeset.apply_changes()
          |> Map.put(:id, id)

        {:ok, farm}

      changeset ->
        {:error, changeset}
    end
  end

  def random_name() do
    Enum.random(@farm_colors) <>
      " " <>
      Enum.random(@farm_names) <>
      " " <>
      to_string(:rand.uniform(Logatron.Limits.max_farms()))
  end

  def random do
    %Logatron.Schema.Farm{
      id:
        Logatron.Schema.Id.new(id_prefix())
        |> Id.as_string(),
      name: random_name(),
      nbr_of_lives:
        normalize(
          abs(
            :rand.uniform(Logatron.Limits.max_lives()) -
              :rand.uniform(Logatron.Limits.max_lives() - Logatron.Limits.min_lives())
          )
        ),
      nbr_of_robots:
        normalize(
          abs(
            :rand.uniform(Logatron.Limits.max_robots()) -
              :rand.uniform(Logatron.Limits.max_robots() - Logatron.Limits.min_robots())
          )
        )
    }
  end

  defp normalize(res) when res > 0, do: res
  defp normalize(res) when res <= 0, do: 1
end
