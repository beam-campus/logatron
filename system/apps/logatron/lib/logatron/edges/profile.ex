defmodule Logatron.Edges.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "profiles" do
    field :name, :string
    field :description, :string
    field :api_key, :string
    field :pub_key, :string
    field :user_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:name, :description, :api_key, :pub_key])
    |> validate_required([:name, :description, :api_key, :pub_key])
  end
end
