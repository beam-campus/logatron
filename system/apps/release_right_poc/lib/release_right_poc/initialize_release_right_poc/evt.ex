defmodule ReleaseRightPoc.InitializeReleaseRightPoc.Evt do
  @moduledoc """
  This module defines the event for initializing the release right POC.
  """

  alias ReleaseRightPoc.InitializeReleaseRightPoc.Evt, as: ReleaseRightPocInitialized

  @all_fields [
    :root_id,
    :terminal_id,
    :container_id
  ]

  @derive {Jason.Encoder, only: @all_fields}
  defstruct [:root_id, :terminal_id, :container_id]

  def from_map(map) do
    %ReleaseRightPocInitialized{
      root_id: map["root_id"],
      terminal_id: map["terminal_id"],
      container_id: map["container_id"]
    }
  end
end
