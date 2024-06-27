defmodule ReleaseRightPoc.InitializeRRPoc.Cmd do
  defstruct [:root_id, :terminal_id, :container_id]

  def from_map(map) do
    %ReleaseRightPoc.InitializeRRPoc.Cmd{
      root_id: map["root_id"],
      terminal_id: map["terminal_id"],
      container_id: map["container_id"]
    }
  end


end
