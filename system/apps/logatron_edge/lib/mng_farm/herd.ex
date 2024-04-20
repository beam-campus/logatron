defmodule Logatron.MngFarm.Herd do
  use GenServer

  alias Logatron.Schema.Life

  require Logger

  @moduledoc """
  The Logatron.Far.Herd.System supervises the Lives in a Herd.
  """

  ################# API ##################
  def populate(mng_farm_init) do
      Enum.to_list(1..mng_farm_init.farm.nbr_of_lives)
      |> Enum.map(&do_new_life/1)
      |> Enum.each(&do_start_born2died(mng_farm_init, &1))
  end

  def birth_calves(mother_state, nbr_of_calves) do
    GenServer.cast(
      via(mother_state.mng_farm_id),
      {:birth_calves, mother_state, nbr_of_calves}
    )

  end

  def which_children(mng_farm_id) do
    DynamicSupervisor.which_children(via_sup(mng_farm_id))
  end

  ################# CALLBACKS ##################
  def handle_cast({:birth_calves, mother, number}, state) do

    Enum.to_list(1..number)
    |> Enum.map(&do_new_life/1)
    |> Enum.each(&do_start_born2died(state, &1))

    {:noreply, state}

  end

  @impl GenServer
  def init(mng_farm_init) do
    DynamicSupervisor.start_link(
      name: via_sup(mng_farm_init.id),
      strategy: :one_for_one
    )

    {:ok, mng_farm_init}
  end

  ############### INTERNALS ################
  defp do_new_life(_) do
    res = Life.random()
    Logger.info("Created new Life: #{inspect(res)}")
    res
  end

  defp do_start_born2died(mng_farm_init, life) do
    DynamicSupervisor.start_child(
      via_sup(mng_farm_init.id),
      {
        Logatron.Born2Died.System,
        Logatron.Born2Died.State.from_life(
          life,
          mng_farm_init
        )
      }
    )
  end

  ################# PLUMBING ##################
  def start_link(mng_farm_init),
    do:
      GenServer.start_link(
        __MODULE__,
        mng_farm_init,
        name: via(mng_farm_init.id)
      )

  def child_spec(mng_farm_init) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [mng_farm_init]},
      type: :supervisor,
      restart: :permanent,
      shutdown: 500
    }
  end

  def to_name(mng_farm_id),
    do: "mng_farm.herd.#{mng_farm_id}"

  def via(mng_farm_id),
    do: Logatron.Registry.via_tuple({:mng_farm_herd, to_name(mng_farm_id)})

  def via_sup(mng_farm_id),
    do: Logatron.Registry.via_tuple({:mng_farm_herd_sup, to_name(mng_farm_id)})
end
