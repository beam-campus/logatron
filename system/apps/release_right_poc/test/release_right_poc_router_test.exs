defmodule ReleaseRightPoc.RouterTest do
  use ExUnit.Case

  alias ReleaseRightPoc.Router

  alias ReleaseRightPoc.InitializeReleaseRightPoc.Cmd, as: InitializeReleaseRightPoc

  test "dispatches InitializeReleaseRightPoc command" do

    ReleaseRightPoc.Application.start(:normal, [])
    
    command = %InitializeReleaseRightPoc{
      root_id: "root_id",
      terminal_id: "terminal_id",
      container_id: "container_id"
    }

    {:ok, _} = Router.dispatch(command)
  end

end
