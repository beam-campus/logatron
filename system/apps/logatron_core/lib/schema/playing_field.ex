defmodule LogatronCore.Schema.Field do
  use Ecto.Schema

  @moduledoc """
  LogatronCore.Schema.Field is the module that contains the field schema
  """

  alias LogatronCore.Schema.{FieldCell}
  alias Schema.Id

  @all_fields [
    :id,
    :name,
    :dimensions,
    :cells
  ]


  @primary_key false
  @derive {Jason.Encoder, only: @all_fields}
  embedded_schema do
    field(:id, :string)
    field(:name, :string)
    embeds_one(:dimensions, LogatronCore.Schema.Vector)
    embeds_many(:cells, LogatronCore.Schema.FieldCell)
  end

  def new(id, name, dimensions) do
    %LogatronCore.Schema.Field{
      id: id,
      name: name,
      dimensions: dimensions,
      cells: build_cells(dimensions)
    }
  end

  def build_cells(dimensions) do
    for x <- 1..dimensions.x,
        y <- 1..dimensions.y,
        z <- 1..dimensions.z do
      %FieldCell{
        id: Id.new("cell", "#{to_string(x)}_#{to_string(y)}_#{to_string(z)}") |> Id.as_string(),
        name: "cell_#{to_string(x)}_#{to_string(y)}_#{to_string(z)}"
      }
    end
  end
end