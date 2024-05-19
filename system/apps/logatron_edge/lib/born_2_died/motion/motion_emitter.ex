defmodule Born2Died.MotionEmitter do
  use GenServer, restart: :transient

  @moduledoc """
  Born2Died.HealthEmitter is a GenServer that manages a channel to client
  """

  alias Born2Died.Movement, as: Movement
  alias Born2Died.State, as: LifeState
  alias Edge.Client, as: Client
  alias Born2Died.Facts, as: LifeFacts

  require Logger

  @life_moved_v1 LifeFacts.life_moved_v1()

  ############ API ############
  def emit_life_moved(%Movement{life: %LifeState{} = life_init} = movement),
    do:
      Client.publish(
        life_init.edge_id,
        @life_moved_v1,
        %{movement: movement}
      )

  ############ CALLBACKS ############

  @impl GenServer
  def handle_cast({:life_moved, %Movement{life: %LifeState{} = life_init} = movement}, state) do
    Client.publish(
      life_init.edge_id,
      @life_moved_v1,
      %{movement: movement}
    )

    {:noreply, state}
  end

  @impl GenServer
  def handle_info({:after_join, _}, state) do
    Logger.debug("motion.emitter received: :after_join")
    {:noreply, state}
  end

  @impl GenServer
  def init(%LifeState{} = life_init) do
    Logger.info("motion.emitter: #{Colors.born2died_theme(self())}")
    {:ok, life_init}
  end   

  ########### PLUMBING ###########
  defp to_name(life_id),
    do: "motion.emitter.#{life_id}"

  def via(life_id),
    do: Edge.Registry.via_tuple(to_name(life_id))

  def start_link(%LifeState{} = life_init),
    do:
      GenServer.start_link(
        __MODULE__,
        life_init,
        name: via(life_init.id)
      )

  def child_spec(%LifeState{} = life_init) do
    %{
      id: to_name(life_init.id),
      start: {__MODULE__, :start_link, [life_init]},
      type: :worker,
      restart: :transient
    }
  end
end
