defmodule Logatron.Born2Died.Worker do
  @moduledoc """
  Logatron.Born2Died.Worker is the worker process that is spawned for each Life.
  """
  use GenServer
  require Logger
  require Logatron.Born2Died.Emitter

  alias Logatron.MngFarm
  alias LogatronEdge.Channel
  alias Logatron.Born2Died.Rules

  ################ INTERFACE ###############
  def live(life_id),
    do:
      GenServer.cast(
        via(life_id),
        {:live}
      )

  def die(life_id),
    do:
      GenServer.cast(
        via(life_id),
        {:die}
      )

  def move(life_id, delta_x, delta_y),
    do:
      GenServer.cast(
        via(life_id),
        {:move, delta_x, delta_y}
      )

  def get_state(life_id),
    do:
      GenServer.call(
        via(life_id),
        {:get_state}
      )

  ################# CALLBACKS #####################
  @impl GenServer
  def init(state) do
    Process.flag(:trap_exit, true)

    Cronlike.start_link(%{
      interval: :rand.uniform(10),
      unit: :second,
      callback_function: &do_cron/1,
      caller_state: state
    })

    Logger.debug(" \n\tBORN: #{state.life.name}  #{state.life.gender}")
    {:ok, state}
  end

  @impl GenServer
  def terminate(reason, state) do
    {:stop, reason, state}
  end

  @impl GenServer
  def handle_info({:EXIT, _from_id, reason}, state) do
    {:stop, reason, state}
  end

  @impl GenServer
  def handle_call({:get_state}, _from, state) do
    Logger.debug(" \n\tGETTING STATE: #{state.life.name}  ")
    {:reply, state, state}
  end

  ################# HANDLE_CAST #####################
  @impl GenServer
  def handle_cast({:live}, state) when state.status == "died" do
    {:noreply, state}
  end

  @impl GenServer
  def handle_cast({:live}, state) do
    new_state =
      state
      |> Rules.calc_age()
      |> Rules.apply_age()
      |> Rules.calc_pos()
      |> do_process()

    {:noreply, new_state}
  end

  @impl GenServer
  def handle_cast({:die}, state),
    do: {:noreply, do_die(state)}

  @impl GenServer
  def handle_cast({:move, delta_x, delta_y}, state),
    do: {:noreply, do_move(state, delta_x, delta_y)}

  ############################### INTERNALS #############################
  defp to_name(life_id),
    do: "born_2_died.worker.#{life_id}"

  defp do_cron(state) do
    state =
      state
      |> do_process()

    live(state.life.id)
    state
  end

  defp do_process(state) do
    state
    |> do_process_health()
    |> do_process_pos()
    |> do_process_reproduce()
  end

  defp do_process_reproduce(state) when state.life.gender == "female" do
    r = :rand.uniform(1000)
    rea = rem(r, 7)
    freq = rem(state.ticks, 32)
    if freq == 2 and rea == 7  and state.vitals.energy >=  65  and state.vitals.health >= 71 do
       MngFarm.Herd.birth_calves(state, 1)
    end
    state
  end

  defp do_process_reproduce(state) do
    state
  end

  defp do_process_health(state) when state.vitals.health <= 0 do
    die(state.life.id)
    state
  end

  defp do_process_health(state),
    do: state

  defp do_process_pos(state) do
    move(state.life.id, :rand.uniform(3), :rand.uniform(3))
    state
  end

  # defp do_process_status(state)  do
  #   # eval_state = Logatron.Born2Died.Rules.eval(state)
  #   # case eval_state.status do
  #   #   :died ->
  #   #     Logatron.Born2Died.Emitter.emit_died(state.life.id, state)
  #   #     Logatron.Born2Died.System.die(state.life.id)
  #   #     state
  #   #   _ ->
  #   #     state
  #   # end

  #   state
  # end

  # defp do_process_status(state) do
  #   Channel.emit_born2died_died(state)
  #   state
  # end

  defp do_die(state) do
    new_state =
      state
      |> Map.put(:status, "died")

    Channel.emit_born2died_died(new_state)

    Logatron.Born2Died.System.stop(state.life.id)

    new_state
  end

  defp do_move(state, delta_x, delta_y) do
    new_state =
      Map.put(state, :pos, do_change_pos(state.pos, delta_x, delta_y))
      |> Map.put(:status, "moving")

    Channel.emit_born2died_state_changed(new_state)

    new_state
  end

  defp do_change_pos(pos, delta_x, delta_y) when is_map(pos) do
    new_pos =
      pos
      |> Map.put(:x, pos.x + delta_x)
      |> Map.put(:y, pos.y + delta_y)

    new_pos
  end

  ################# PLUMBING #####################
  def via(life_id),
    do: Logatron.Registry.via_tuple(to_name(life_id))

  def child_spec(born2died_init) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [born2died_init]},
      type: :worker,
      restart: :transient
    }
  end

  def start_link(state),
    do:
      GenServer.start_link(
        __MODULE__,
        state,
        name: via(state.life.id)
      )
end
