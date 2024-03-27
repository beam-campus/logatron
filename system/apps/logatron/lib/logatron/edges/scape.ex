defmodule Logatron.Edges.Scape do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "scapes" do
    field :name, :string
    field :description, :string
    field :overrides, :string
    field :leaf_id, :binary_id
    field :model_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(scape, attrs) do
    scape
    |> cast(attrs, [:name, :description, :overrides])
    |> validate_required([:name, :description, :overrides])
  end
end
