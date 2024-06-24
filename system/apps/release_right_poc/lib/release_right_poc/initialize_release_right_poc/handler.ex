defmodule ReleaseRightPoc.InitializeReleaseRightPoc.Handler do
  @moduledoc """
  This module defines the handler for initializing the release right POC.
  """
  @behaviour Commanded.Commands.Handler

  alias ReleaseRightPoc.Aggregate,  as: Aggregate
  alias ReleaseRightPoc.InitializeReleaseRightPoc.Cmd,    as: InitializePoc

  def handle(
        %Aggregate{} = aggregate,
        %InitializePoc{} = command
      ) do
    aggregate
    |> Aggregate.execute(command)
  end
end
