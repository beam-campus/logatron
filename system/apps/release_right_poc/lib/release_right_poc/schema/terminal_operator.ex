defmodule ReleaseRightPoc.Schema.TerminalOperator do
  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:name, :string)
  end
end
