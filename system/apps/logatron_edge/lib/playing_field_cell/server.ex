defmodule PlayingFieldCell.Server do
  use GenServer


  @moduledoc """
  PlayingFieldCell.Server is a GenServer that manages the state of a PlayingFieldCell.
  """

  require Logger


  ############# API #############
  def add_occupant(cell_id, occupant),
  do:
    GenServer.cast(
      via(cell_id),
      {:add_occupant, occupant}
    )


  def remove_occupant(cell_id, occupant_id) do
    GenServer.cast(
      via(cell_id),
      {:remove_occupant, occupant_id}
    )
  end

  def get_occupants(cell_id) do
    GenServer.call(
      via(cell_id),
      {:get_occupants}
    )
  end

  def get_state(cell_id) do
    GenServer.call(
      via(cell_id),
      {:get_state}
    )
  end



  ################ CALLBACKS ################
@impl GenServer
  def handle_cast({:add_occupant, occupant}, cell_state) do
    new_occupants = [occupant | cell_state.occupants]
    {:noreply, %{cell_state | occupants: new_occupants}}
  end

  @impl GenServer
  def handle_cast({:remove_occupant, occupant_id}, cell_state) do
    new_occupants = cell_state.occupants
    |> Enum.reject(fn occupant -> occupant.id == occupant_id end)
    {:noreply, %{cell_state | occupants: new_occupants}}
  end


  @impl GenServer
  def handle_call({:get_occupants}, _from, cell_state) do
    {:reply, cell_state.occupants, cell_state}
  end

  @impl GenServer
  def handle_call({:get_state}, _from, cell_state) do
    {:reply, cell_state, cell_state}
  end





  @impl GenServer
  def init(cell_init) do
    {:ok, %{meta: cell_init, occupants: [], actors: []}}
  end


  ################# PLUMBING #################
  defp to_name(cell_id),
    do: "playing_field_cell.server.#{cell_id}"


  def via(cell_id),
    do: Logatron.Registry.via_tuple({:playing_field_cell_sys, to_name(cell_id)})

  def via_sup(cell_id),
    do: Logatron.Registry.via_tuple({:playing_field_cell_sup, to_name(cell_id)})

  def start_link(cell_init) do
    GenServer.start_link(
      __MODULE__,
      cell_init,
      name: via(cell_init.id)
    )
  end

  def child_spec(cell_init) do
    %{
      id: to_name(cell_init.id),
      start: {__MODULE__, :start_link, [cell_init]},
      type: :supervisor,
      restart: :permanent,
      shutdown: 500
    }
  end

end
