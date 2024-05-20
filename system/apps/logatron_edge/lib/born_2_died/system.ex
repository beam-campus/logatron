defmodule Born2Died.System do
  use GenServer

  @moduledoc """
  The Life System is a GenServer that manages the
  Life Worker and Life Channel
  """

  require Logger

  alias Born2Died.State, as: LifeState
  alias MngFarm.Emitter, as: FarmChannel
  alias Born2Died.MotionEmitter, as: MotionChannel

  def do_birth(life_id, delta_x, delta_y),
    do:
      GenServer.cast(
        via(life_id),
        {:do_birth, life_id, delta_x, delta_y}
      )

  def stop(life_id) do
    try do
      Supervisor.stop(via_sup(life_id), :shutdown)
    rescue
      _ -> :ok
    end
  end

  def register_movement(life_id, movement),
    do:
      GenServer.cast(
        via(life_id),
        {:register_movement, movement}
      )

  def get_state(life_id),
    do:
      GenServer.call(
        via(life_id),
        {:get_state}
      )

  ########################## CALLBACKS ####################################
  @impl GenServer
  def init(%LifeState{} = state) do
    # Process.flag(:trap_exit, true)
    Logger.debug("born2died.system: #{Colors.born2died_theme(self())}")

    children =
      [
        {Born2Died.HealthEmitter, state},
        {Born2Died.HealthWorker, state},
        {Born2Died.MotionEmitter, state},
        {Born2Died.MotionWorker, state}

        # {Born2Died.AiWorker, state},
        # {Born2Died.VisionWorker, state},
        # {Born2Died.MilkingWorker, state},
        # {Born2Died.CombatWorker, state},
        # {Born2Died.MatingWorker, state}
      ]

    Supervisor.start_link(
      children,
      name: via_sup(state.life.id),
      strategy: :one_for_one
    )

    {:ok, state}
  end

  ############### CALLBACKS ############################
  @impl GenServer
  def terminate(_reason, _state) do
    :ok
  end

  @impl GenServer
  def handle_call({:get_state}, _from, state),
    do: {:reply, state, state}

  @impl GenServer
  def handle_cast({:register_movement, movement}, state) do

    Logger.alert("Movement: #{state.pos} -> #{movement.to} ")
    state =
      state
      |> Map.put(:pos, movement.to)

    movement =
      movement
      |> Map.put(:life, state)

    MotionChannel.emit_life_moved(movement)

    {:noreply, state}
  end

  ######### handle_info #################
  @impl GenServer
  def handle_info({:EXIT, _from_id, reason}, state) do
    # Born2Died.HealthWorker.die(state.life.id)
    {:stop, reason, state}
  end

  ######### INTERNALS ###################
  defp to_name(life_id),
    do: "life.system.#{life_id}"

  ############# PLUMBING ##################
  def via(life_id),
    do: Edge.Registry.via_tuple({:life_sys, to_name(life_id)})

  def via_sup(life_id),
    do: Edge.Registry.via_tuple({:life_sup, to_name(life_id)})

  def via_pubsub(life_id),
    do: Edge.Registry.via_tuple({:life_pubsub, to_name(life_id)})

  def child_spec(%LifeState{} = state) do
    %{
      id: to_name(state.life.id),
      start: {__MODULE__, :start_link, [state]},
      type: :supervisor,
      restart: :transient
    }
  end

  def start_link(%LifeState{} = state),
    do:
      GenServer.start_link(
        __MODULE__,
        state,
        name: via(state.life.id)
      )
end
