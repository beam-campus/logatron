defmodule Logatron.Schema.Vector do
  use Ecto.Schema

  @moduledoc """
  Logatron.Schema.Vector is the module that contains the vector schema
  """

  import Ecto.Changeset

  @all_fields [
    :x,
    :y,
    :z
  ]

  @derive {Jason.Encoder, only: @all_fields}
  @primary_key false
  embedded_schema do
    field :x, :integer
    field :y, :integer
    field :z, :integer
  end

  def new(x, y, z) do
    %Logatron.Schema.Vector{
      x: x,
      y: y,
      z: z
    }
  end


  def random(max_x, max_y, max_z) do
    x = :rand.uniform(max_x)
    y = :rand.uniform(max_y)
    z = :rand.uniform(max_z)
    new(x, y, z)
  end

  def changeset(vector, attr) do
    vector
    |> cast(attr, @all_fields)
    |> validate_required(@all_fields)
  end



end
