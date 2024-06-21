defmodule ReleaseRightPoc.Aggregate do
  defstruct [:root_id, :state]

  alias ReleaseRightPoc.States, as: States
  alias ReleaseRightPoc.Aggregate, as: Aggregate
  alias ReleaseRightPoc.Schema.Root, as: Root

  def execute(
        %Aggregate{} = aggregate,
        %ReleaseRightPoc.InitializeReleaseRightPoc.Cmd{} = cmd
      ) do
    {:ok,
     %ReleaseRightPoc.InitializeReleaseRightPoc.Evt{
       root_id: cmd.root_id,
       terminal_id: cmd.terminal_id,
       container_id: cmd.container_id
     }}
  end

  def apply(%Aggregate{} = aggregate, %ReleaseRightPoc.InitializeReleaseRightPoc.Evt{} = evt) do
    %Aggregate{
      root_id: evt.root_id,
      state: %Root{status: States.initialized()}
    }
  end
end
