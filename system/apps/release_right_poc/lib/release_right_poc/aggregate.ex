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

  alias ReleaseRightPoc.InitializeRRPoc.Cmd,
    as: InitializeRRPoc

  alias ReleaseRightPoc.InitializeRRPoc.Evt,
    as: RRPocInitialized

  alias ReleaseRightPoc.InitializeRRDoc.Cmd,
    as: InitializeRRDoc

  alias ReleaseRightPoc.InitializeRRDoc.Evt,
    as: RRDocInitialized

  alias Commanded.Aggregate.Multi,
    as: Multi

  @poc_initialized States.initialized()
  @doc_initialized States.doc_initialized()

  ##### INTERNALS #####

  defp raise_initialize_events(aggregate, cmd) do
    aggregate
    |> Multi.new()
    |> Multi.execute(&initialize_poc(&1, cmd))
    |> Multi.execute(&initialize_doc(&1, cmd))
  end

  defp initialize_poc(_agg, %InitializeRRPoc{} = cmd) do
    {:ok,
     %RRPocInitialized{
       root_id: cmd.root_id,
       terminal_id: cmd.terminal_id,
       container_id: cmd.container_id
     }}
  end

  defp initialize_doc(_agg, %InitializeRRPoc{} = cmd) do
    {:ok,
     %RRDocInitialized{
       root_id: cmd.root_id,
       terminal_id: cmd.terminal_id,
       container_id: cmd.container_id
     }}
  end

  ############### API ###############

  def execute(
        %Aggregate{state: nil} = aggregate,
        %InitializeRRPoc{} = cmd
      ) do
    raise_initialize_events(aggregate, cmd)
  end

  def execute(
        %Aggregate{state: %Root{} = state} = aggregate,
        %InitializeRRPoc{} = cmd
      ) do
    cond do
      Flags.has?(state.status, States.unknown()) ->
        raise_initialize_events(aggregate, cmd)

      Flags.has?(state.status, States.initialized()) ->
        {:error, :already_initialized}

      true ->
        {:error, :already_initialized}
    end
  end

  def apply(
        %Aggregate{state: nil} = _aggregate,
        %RRPocInitialized{} = evt
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
        %RRPocInitialized{} = evt
      ),
      do: %Aggregate{
        aggregate
        | root_id: evt.root_id,
          state: %Root{
            id: evt.root_id,
            status: States.initialized()
          }
      }

  def apply(
        %Aggregate{state: %Root{} = state} = aggregate,
        %RRDocInitialized{} = _evt
      ) do
    %Aggregate{
      aggregate
      | state: %Root{
          state
          | status: Flags.set(state.status, @doc_initialized)
        }
    }
  end
end
