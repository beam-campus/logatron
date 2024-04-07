defmodule Logatron.Scapes.Animal do
  use Ecto.Schema

  @moduledoc """
  Logatron.Scapes.Animal contains the Ecto schema for the Animal.
  """

  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:name, :string)
    field(:gender, :string)
    field(:age, :integer)
    field(:weight, :integer)
    field(:energy, :integer)
    field(:is_pregnant, :boolean)
    field(:heath, :integer)
    field(:health, :integer)
    embeds_one(:position, Logatron.Schema.Vector)
  end

end
