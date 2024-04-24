defmodule LogatronCore.Schema.PlayingField do
  use Ecto.Schema

  @moduledoc """
  LogatronCore.Schema.Field is the module that contains the field schema
  """

  alias LogatronCore.Schema.{Vector, FieldCell}
  alias Logatron.Schema.Id

  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:name, :string)
    embeds_one(:dimensions, LogatronCore.Schema.Vector)
    embeds_many(:cells, LogatronCore.Schema.FieldCell)
  end

  def new(id, name, dimensions) do
    %LogatronCore.Schema.PlayingField{
      id: id,
      name: name,
      dimensions: dimensions,
      cells: build_cells(dimensions)
    }
  end

  def build_cells(dimensions) do
    for x <- 1..dimensions.x, y <- 1..dimensions.y, z <- 1..dimensions.z do
      %LogatronCore.Schema.FieldCell{
        id: Id.new("cell", "#{to_string(x)}_#{to_string(y)}_#{to_string(z)}") |> Id.as_string(),
        name: "cell_#{to_string(x)}_#{to_string(y)}_#{to_string(z)}",
      }
    end
  end
end
