defmodule ReleaseRightPoc.InitializeRRDoc.Handler do


    @moduledoc """
    This module defines the handler for initializing the release right POC.
    """
    @behaviour Commanded.Commands.Handler

    alias ReleaseRightPoc.Aggregate,  as: Aggregate
    alias ReleaseRightPoc.InitializeRRDoc.Cmd,
    as: InitializeRRDoc

    def handle(
          %Aggregate{} = aggregate,
          %InitializeRRDoc{} = command
        ) do
      aggregate
      |> Aggregate.execute(command)
    end



end
