defmodule Logatron.Born2Died.Aggregate do
  use GenServer

  @moduledoc """
  Aggregate is a GenServer that holds the state of a Life.
  """

  require Logger
  require Logatron.Born2Died.Hopes
  require Logatron.Born2Died.Facts
  alias Logatron.Born2Died.Hopes
  alias Logatron.Born2Died.Facts

  ############## COMMAND HANDLERS ####
  def build_state(agg_id) do
    GenServer.call(via(agg_id), :build_state)
  end

  def execute(Hopes.initialize_v1(), %{meta: %{agg_id: agg_id}} = hope),
    do: GenServer.call(via(agg_id), {:initialize, hope})

  ############## MUTATORS ##########
  defp source_event(
         %{
           topic: Facts.born_v1(),
           meta: _meta,
           payload: _payload
         } = _event,
         state
       ) do
    state
    |> Map.put(:status, Flags.set(state.status, 1))
  end

  ################ CALLBACKS #######

  @impl GenServer
  def terminate(reason, _state) do
    Logger.debug(" \t\tDIED: #{inspect(reason)}")
    :ok
  end


  @impl GenServer
  def handle_call(:build_state, _from, %{state: old_state, events: events} = _state) do
    state =
      events
      |> Enum.reduce(old_state, &source_event(&1, &2))

    {:reply, [state: state, events: events], %{state: state, events: events}}
  end

  @impl GenServer
  def handle_cast(
        {:initialize, %{meta: meta, payload: payload} = _hope},
        %{status: status, events: events} = state
      ) do
    case Flags.has(status, 1) do
      true ->
        {:reply, state, state}

      false ->
        meta |> Map.put(:order, 1)

        new_state =
          state
          |> Map.put(
            :events,
            [Logatron.Schema.Fact.new("Logatron.born2died.born.v1", meta, payload)] ++ events
          )

        {:noreply, new_state}
    end
  end

  @impl GenServer
  def init(state) do
    {:ok,
     %{
       state: state,
       events: []
     }}
  end

  ########## PLUMBING ##############
  def start_link(state) do
    GenServer.start_link(
      __MODULE__,
      state,
      name: via(state.id)
    )
  end

  def via(agg_id),
    do: Logatron.Registry.via_tuple({:aggregate, to_name(agg_id)})

  def to_name(agg_id),
    do: "born_2_died.aggregate.#{agg_id}"

  def child_spec(state) do
    %{
      id: via(state.id),
      start: {__MODULE__, :start_link, [state]},
      type: :worker,
      restart: :transient
    }
  end
end
