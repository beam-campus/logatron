defmodule ReleaseRightPoc.Router do
  use Commanded.Commands.Router

  dispatch(
    ReleaseRightPoc.InitializeReleaseRightPoc.Cmd,
    to: ReleaseRightPoc.InitializeReleaseRightPoc.Handler,
    aggregate: ReleaseRightPoc.InitializeReleaseRightPoc.Aggregate,
    identity: :root_id
  )
end
