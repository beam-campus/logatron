defmodule ReleaseRightPoc.Router do
  use Commanded.Commands.Router

  alias ReleaseRightPoc.InitializeReleaseRightPoc.Cmd,
    as: InitializePoc

  alias ReleaseRightPoc.InitializeReleaseRightPoc.Handler,
    as: InitializePocHandler

  alias ReleaseRightPoc.Aggregate,
    as: Aggregate


    alias ReleaseRightPoc.InitializeRRDoc.Cmd,
    as: InitializeRRDoc

    alias ReleaseRightPoc.InitializeRRDoc.Handler,
    as: InitializeRRDocHandler

  # identity(Aggregate,
  #   by: :root_id,
  #   prefix: "release_right_poc"
  # )

  dispatch(InitializePoc,
    to: InitializePocHandler,
    aggregate: Aggregate,
    identity: :root_id
  )

  dispatch(InitializeRRDoc,
    to: InitializeRRDocHandler,
    aggregate: Aggregate,
    identity: :root_id
  )




end
