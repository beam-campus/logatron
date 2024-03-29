defmodule Logatron.MngStations.Schema.StationNode do
  use Ecto.Schema

  @moduledoc """
  Schema for StationNode.
  """
  import Ecto.Changeset
  alias Logatron.MngStations.Schema.Device


  @all_fields [
    :role,
    :brand,
    :model,
    :memory,
    :storage,
    :link_type,
    :opsys
  ]

  @required_fields [
    :role,
    :brand,
    :model,
    :memory,
    :storage,
    :link_type,
    :opsys
  ]

  @primary_key {:id, :binary_id, autogenerate: true}
  embedded_schema do
    field :role, :string
    field :brand, :string
    field :model, :string
    field :memory, :integer
    field :storage, :integer
    field :link_type, :string
    field :opsys, :string
  end

  def changeset(profile, attrs) do
    profile
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
  end

end
