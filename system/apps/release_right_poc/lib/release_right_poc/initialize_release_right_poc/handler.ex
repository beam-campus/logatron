defmodule ReleaseRightPoc.InitializeReleaseRightPoc.Handler do
  use Commanded.Commands.Handler

  alias ReleaseRightPoc.Aggregate, as: Aggregate

  def handle(%Aggregate{} = aggregate, %ReleaseRightPoc.InitializeReleaseRightPoc.Cmd{} = command) do
    aggregate
    |> Aggregate.initialize_release_right_poc(command)
  end
end
