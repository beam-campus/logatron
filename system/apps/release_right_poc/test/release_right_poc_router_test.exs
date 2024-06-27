defmodule ReleaseRightPoc.RouterTest do
  use ExUnit.Case

  alias ReleaseRightPoc.Router

  alias ReleaseRightPoc.InitializeRRPoc.Cmd, as: InitializeRRPoc

  test "dispatches InitializeRRPoc command" do

    ReleaseRightPoc.Application.start(:normal, [])

    command = %InitializeRRPoc{
      root_id: "root_id",
      terminal_id: "terminal_id",
      container_id: "container_id"
    }

    {:ok, _} = Router.dispatch(command)
  end

end
