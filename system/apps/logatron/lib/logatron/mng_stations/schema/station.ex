defmodule Logatron.MngStations.Schema.Station do
  use Ecto.Schema

  @moduledoc """
  Schema for the YourStations component.
  """
  import Ecto.Changeset

  alias Logatron.MngStations.Schema.StationNode

  @all_fields [
    :name,
    :description,
    :user_email,
    :architecture
  ]

  @required_fields [
    :name,
    :description,
    :user_email,
    :architecture
  ]


  @primary_key {:id, :binary_id, autogenerate: true}
  embedded_schema do
    field :name, :string
    field :description, :string
    field :user_email, :string
    field :architecture, :string
    embeds_many :station_nodes, StationNode
  end

  def changeset(station, attrs \\ %{}) do
    station
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
  end



end
