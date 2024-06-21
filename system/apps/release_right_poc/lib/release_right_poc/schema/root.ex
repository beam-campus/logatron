defmodule ReleaseRightPoc.Schema.Root do
  use Ecto.Schema

  alias ReleaseRightPoc.Schema.TerminalOperator, as: TerminalOperator

  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:status, :integer)
    embeds_one(:terminal_operator, TerminalOperator)
  end
end
