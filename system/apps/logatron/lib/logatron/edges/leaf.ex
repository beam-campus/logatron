defmodule Logatron.Edges.Leaf do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "leafs" do
    field :name, :string
    field :description, :string
    field :api_key, :string
    field :pub_key, :string
    field :ip_address, :string
    field :profile_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(leaf, attrs) do
    leaf
    |> cast(attrs, [:name, :description, :api_key, :pub_key, :ip_address])
    |> validate_required([:name, :description, :api_key, :pub_key, :ip_address])
  end
end
