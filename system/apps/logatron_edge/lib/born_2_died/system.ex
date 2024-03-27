defmodule Logatron.Born2Died.System do
  use GenServer

  @moduledoc """
  The Life System is a GenServer that manages the
  Life Worker and Life Channel
  """

  require Logger

  ######### API #####################
  # def live(life_id),
  #   do:
  #     GenServer.cast(
  #       via(life_id),
  #       {:live, life_id}
  #     )

  # def die(life_id),
  #   do:
  #     GenServer.cast(
  #       via(life_id),
  #       {:die, life_id}
  #     )

  def stop(life_id) do
    try do
      Supervisor.stop(via_sup(life_id), :shutdown)
    rescue
      _ -> :ok
    end
  end

  ########################## CALLBACKS ####################################
  @impl GenServer
  def init(state) do
    # Process.flag(:trap_exit, true)

    children =
      [
        # {Logatron.Born2Died.Aggregate, state, log: :false},
        # {Logatron.Born2Died.Emitter, state},
        {Logatron.Born2Died.Worker, state}
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

  ######### handle_info
  @impl GenServer
  def handle_info({:EXIT, _from_id, reason}, state) do
    # Logatron.Born2Died.Worker.die(state.life.id)
    {:stop, reason, state}
  end

  ######## handle_cast
  # @impl GenServer
  # def handle_cast({:live, life_id}, state) do
  #   Logatron.Born2Died.Worker.live(life_id)
  #   {:noreply, state}
  # end

  # def handle_cast({:die, life_id}, state) do
  #   Logatron.Born2Died.Worker.die(life_id)
  #   {:noreply, state}
  # end

  ########################## INTERNALS ########################################
  defp to_name(life_id),
    do: "born_2_died.system.#{life_id}"

  ############# PLUMBING ##################
  def via(life_id),
    do: Logatron.Registry.via_tuple({:born2died_sys, to_name(life_id)})

  def via_sup(life_id),
    do: Logatron.Registry.via_tuple({:born2died_sup, to_name(life_id)})

  def child_spec(state) do
    %{
      id: to_name(state.life.id),
      start: {__MODULE__, :start_link, [state]},
      type: :supervisor,
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
