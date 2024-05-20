defmodule Born2Died.MotionWorker do
  use GenServer, restart: :transient

  @moduledoc """
  Born2Died.MotionWorker is a GenServer that manages the movements of a life
  """

  require Logger

  alias Born2Died.MotionEmitter
  alias Born2Died.Movement
  alias Born2Died.State, as: LifeState
  alias Born2Died.Movement, as: Movement
  alias Born2Died.System, as: LifeSystem
  alias Born2Died.MotionEmitter, as: MotionChannel

  ################ INTERFACE ############

  def move(life_init_id, %Movement{} = movement),
    do:
      GenServer.cast(
        via(life_init_id),
        {:move, movement}
      )

  ############### INTERNALS #############

  defp try_move(%{state: life_init, movement: movement}),
    do: move(life_init.id, movement)

  ############### CALLBACKS #############

  @impl GenServer
  def init(%LifeState{} = state) do
    Logger.info("motion.worker: #{Colors.born2died_theme(self())}")

    Cronlike.start_link(%{
      interval: :rand.uniform(10),
      unit: :second,
      callback_function: &try_move/1,
      caller_state: %{state: state, movement: Movement.random(state)}
    })

    {:ok, state}
  end

  @impl GenServer
  def handle_cast({:move, %Movement{} = movement}, state) do
    state =
      state
      |> Map.put(:pos, movement.to)

    movement =
      movement
      |> Map.put(:life, state)

      MotionChannel.emit_life_moved(movement)

    LifeSystem.register_movement(state.id, movement)



    {:noreply, state}
  end

  ########### PLUMBING ###########

  def via(life_init_id),
    do: Edge.Registry.via_tuple({:motion_worker, to_name(life_init_id)})

  def to_name(life_init_id),
    do: "life.motion_worker.#{life_init_id}"

  def child_spec(%LifeState{} = life_init),
    do: %{
      id: to_name(life_init.id),
      start: {__MODULE__, :start_link, [life_init]},
      type: :worker,
      restart: :transient
    }

  def start_link(%LifeState{} = state),
    do:
      GenServer.start_link(
        __MODULE__,
        state,
        name: via(state.id)
      )
end
