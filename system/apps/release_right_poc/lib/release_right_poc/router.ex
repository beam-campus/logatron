defmodule ReleaseRightPoc.Router do
  use Commanded.Commands.Router

  alias ReleaseRightPoc.InitializeReleaseRightPoc.Cmd,
    as: InitializePoc

  alias ReleaseRightPoc.InitializeReleaseRightPoc.Handler,
    as: InitializePocHandler

  alias ReleaseRightPoc.Aggregate,
    as: Aggregate

  # identity(Aggregate,
  #   by: :root_id,
  #   prefix: "release_right_poc"
  # )

  dispatch(InitializePoc,
    to: InitializePocHandler,
    aggregate: Aggregate,
    identity: :root_id
  )



  
end
