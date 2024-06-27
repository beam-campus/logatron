defmodule ReleaseRightPoc.InitializeRRDoc.Evt do
  
  alias ReleaseRightPoc.InitializeRRDoc.Evt,
    as: RRDocInitialized

  @all_fields [
    :root_id,
    :terminal_id,
    :container_id
  ]

  @derive {Jason.Encoder, only: @all_fields}
  defstruct [:root_id, :terminal_id, :container_id]

  def from_map(map) do
    %RRDocInitialized{
      root_id: map["root_id"],
      terminal_id: map["terminal_id"],
      container_id: map["container_id"]
    }
  end
end
