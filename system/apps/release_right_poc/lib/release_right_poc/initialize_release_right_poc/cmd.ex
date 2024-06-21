defmodule ReleaseRightPoc.InitializeReleaseRightPoc.Cmd do
  defstruct [:root_id, :terminal_id, :container_id]

  def from_map(map) do
    %ReleaseRightPoc.InitializeReleaseRightPoc.Cmd{
      root_id: map["root_id"],
      terminal_id: map["terminal_id"],
      container_id: map["container_id"]
    }
  end


end
