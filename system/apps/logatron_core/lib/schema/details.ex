defmodule Schema.Details do

  use Ecto.Schema

  @moduledoc """
  Schema.Details is the struct that identifies the details of a Fact.
  """


  @primary_key false
  embedded_schema do
    field(:name, :string)
    field(:description, :string)
  end

  def new(name, description),
      do: %__MODULE__{
        name: name,
        description: description
      }
end
