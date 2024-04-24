defmodule Logatron.MngFarm.Server do
  use GenServer

  alias Logatron.Schema.Life
  require DynamicSupervisor
  require Logger

  alias PlayingField.InitParams, as: FieldInit
  alias Logatron.Born2Died.System, as: Born2DiedSystem
  alias Born2Died.State, as: Born2DiedState

  alias Logatron.MngFarm.InitParams, as: MngFarmInit


  @moduledoc """
  The Logatron.Far.Herd.System supervises the Lives in a Herd.
  """

  ################# API ##################
  def populate(%MngFarmInit{} = mng_farm_init) do
    Enum.to_list(1..mng_farm_init.farm.nbr_of_lives)
    |> Enum.map(&do_new_life/1)
    |> Enum.each(&do_start_born2died(&1, mng_farm_init))
  end

  def generate_fields(%MngFarmInit{} = mng_farm_init) do
    Enum.to_list(1..mng_farm_init.max_depth)
    |> Enum.map(&FieldInit.from_mng_farm(&1, mng_farm_init))
    |> Enum.each(&start_field/1)
  end

  def start_field(%FieldInit{} = field_init),
    do:
      DynamicSupervisor.start_child(
        via_sup(field_init.farm_id),
        {PlayingField.System, field_init}
      )

  def birth_calves(mother_state, nbr_of_calves),
    do:
      GenServer.cast(
        via(mother_state.farm_id),
        {:birth_calves, mother_state, nbr_of_calves}
      )

  def which_children(mng_farm_id) do
    DynamicSupervisor.which_children(via_sup(mng_farm_id))
  end

  ################# CALLBACKS ##################

  @impl GenServer
  def handle_cast({:birth_calves, _mother, number}, state) do
    Enum.to_list(1..number)
    |> Enum.map(&do_new_life/1)
    |> Enum.each(& do_start_born2died(&1, state))

    {:noreply, state}
  end

  @impl GenServer
  def init(mng_farm_init) do
    DynamicSupervisor.start_link(
      name: via_sup(mng_farm_init.farm_id),
      strategy: :one_for_one
    )

    {:ok, mng_farm_init}
  end

  ############### INTERNALS ################

  defp do_new_life(_),
    do: Life.random()

  defp do_start_born2died(%Life{} = life, %MngFarmInit{} = mng_farm_init) do
    DynamicSupervisor.start_child(
      via_sup(mng_farm_init.farm_id),
      {
        Born2DiedSystem, Born2DiedState.from_life(life, mng_farm_init)
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
      id: to_name(mng_farm_init.id),
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
