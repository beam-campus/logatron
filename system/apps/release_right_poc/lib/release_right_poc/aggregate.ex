defmodule ReleaseRightPoc.Aggregate do
  @moduledoc """
  This module defines the aggregate for the release right POC.
  """


  defstruct [:root_id, :state]

  alias ReleaseRightPoc.Schema.Root,
    as: Root

  alias ReleaseRightPoc.Schema.States,
    as: States

  alias ReleaseRightPoc.Aggregate,
    as: Aggregate

  alias Flags,
    as: Flags

  alias ReleaseRightPoc.InitializeReleaseRightPoc.Cmd,
    as: InitializeReleaseRightPoc

  alias ReleaseRightPoc.InitializeReleaseRightPoc.Evt,
    as: ReleaseRightPocInitialized



  def execute(
        %Aggregate{state: nil} = _aggregate,
        %InitializeReleaseRightPoc{} = cmd
      ) do
    {:ok,
     %ReleaseRightPocInitialized{
       root_id: cmd.root_id,
       terminal_id: cmd.terminal_id,
       container_id: cmd.container_id
     }}
  end

  def execute(
        %Aggregate{state: %Root{} = state} = _aggregate,
        %InitializeReleaseRightPoc{} = cmd
      ) do
    cond do
      Flags.has?(state.status, States.unknown()) ->
        {:ok,
         %ReleaseRightPocInitialized{
           root_id: cmd.root_id,
           terminal_id: cmd.terminal_id,
           container_id: cmd.container_id
         }}

      Flags.has?(state.status, States.initialized()) ->
        {:error, :already_initialized}

      true ->
        {:error, :already_initialized}
    end
  end

  def apply(
        %Aggregate{state: nil} = _aggregate,
        %ReleaseRightPocInitialized{} = evt
      ),
      do: %Aggregate{
        root_id: evt.root_id,
        state: %Root{
          id: evt.root_id,
          status: States.unknown()
        }
      }

  def apply(
        %Aggregate{} = aggregate,
        %ReleaseRightPocInitialized{} = evt
      ),
      do: %Aggregate{
        aggregate
        | root_id: evt.root_id,
          state: %Root{
            id: evt.root_id,
            status: States.initialized()
          }
      }
end
