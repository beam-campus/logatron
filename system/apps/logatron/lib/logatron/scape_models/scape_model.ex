defmodule Logatron.ScapeModels.ScapeModel do
  use Ecto.Schema

  @moduledoc """
  The schema for the ScapeModel model.
  """

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "scape_models" do
    field :name, :string
    field :description, :string
    field :definition, :string

    timestamps()
  end

  @doc false
  def changeset(scape_model, attrs) do
    scape_model
    |> cast(attrs, [:name, :description, :definition])
    |> validate_required([:name, :description, :definition])
  end
end
