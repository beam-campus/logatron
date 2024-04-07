defmodule LogatronEdge.InitParams do
  use Ecto.Schema

  @moduledoc """
  LogatronEdge.InitParams is the struct that identifies the state of a Region.
  """
  alias LogatronEdge.InitParams
  alias AppUtils

  import Ecto.Changeset

  @all_fields [
    :id,
    :api_key,
    :is_container
  ]

  @required_fields [
    :id,
    :api_key,
    :is_container
  ]

  @derive {Jason.Encoder, only: @all_fields}
  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:api_key, :string)
    field(:is_container, :boolean, default: false)
  end

  def changeset(edge, args)
      when is_map(args),
      do:
        edge
        |> cast(args, @all_fields)
        |> validate_required(@required_fields)

  def from_map(map) when is_map(map) do
    case(changeset(%InitParams{}, map)) do
      %{valid?: true} = changeset ->
        edge_init =
          changeset
          |> Ecto.Changeset.apply_changes()

        {:ok, edge_init}

      changeset ->
        {:error, changeset}
    end
  end

  def default,
    do: %InitParams{
      id: Logatron.Schema.Edge.random_id(),
      api_key: "europe_",
      is_container: AppUtils.running_in_container?()
    }

  def from_environment do
    {:ok, chost} = :inet.gethostname()
    edge_id = Logatron.Schema.Edge.random_id() <> "_#{to_string(chost)}"
    if_addr =
    api_key =
      case System.get_env("LOGATRON_EDGE_API_KEY") do
        nil -> "no-api-key"
        key -> key
      end

    %InitParams{
      id: edge_id,
      api_key: api_key,
      is_container: AppUtils.running_in_container?()
    }
  end
end
