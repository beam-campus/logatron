defmodule LogatronEdge.Scape.System do
  @moduledoc """
  LogatronEdge.Scape.System is the top-level supervisor for the Logatron.MngScape subsystem.
  """
  use GenServer

  import Logger

  alias LogatronEdge.Channel

  ################# INTERFACE #############
  def start_europe do
    case start_link(LogatronEdge.Scape.InitParams.europe()) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        {:ok, pid}
    end
  end

  def start_asia do
    case start_link(LogatronEdge.Scape.InitParams.asia()) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        {:ok, pid}
    end
  end

  def start_region_system(scape_id, region_init) do
    Logger.debug("for [#{scape_id}] with region_init #{inspect(region_init)}")

    GenServer.cast(
      via(scape_id),
      {:start_region_system, region_init}
    )
  end

  @doc """
  Returns the list of children supervised by this module
  """
  def which_children(scape_id) do
    try do
      Supervisor.which_children(via_sup(scape_id))
      |> Enum.reverse()
    rescue
      _ -> []
    end
  end

  ######## CALLBACKS ############
  @impl GenServer
  def handle_info({:EXIT, from_pid, reason}, state) do
    Logger.error(
      "#{Colors.red_on_black()}EXIT received from #{inspect(from_pid)} reason: #{inspect(reason)}#{Colors.reset()}"
    )

    {:noreply, state}
  end

  @impl GenServer
  def handle_cast({:start_region_system, region_init}, %{id: scape_id} = scape_init) do
    debug("in:region_init=#{inspect(region_init)}")

    Supervisor.start_child(
      via_sup(scape_id),
      {Logatron.Region.System, region_init}
    )

    {:noreply, scape_init}
  end

  @impl GenServer
  def init(%{id: scape_id} = scape_init) do
    Process.flag(:trap_exit, true)

    Channel.initializing_scape(scape_init)

    children = [
      {LogatronEdge.Scape.Regions, scape_init},
      {LogatronEdge.Scape.Builder, scape_init}
    ]

    Supervisor.start_link(
      children,
      strategy: :one_for_one,
      name: via_sup(scape_id)
    )

    LogatronEdge.Scape.Builder.init_scape(scape_init)

    Channel.scape_initialized(scape_init)

    {:ok, scape_init}
  end

  ################# PLUMBIMG #####################
  def via(key),
    do: Logatron.Registry.via_tuple({:scape_system, to_name(key)})

  def via_sup(key),
    do: Logatron.Registry.via_tuple({:scape_sup, to_name(key)})

  def to_name(key) when is_bitstring(key),
    do: "scape.system.#{key}"

  def child_spec(%{id: scape_id} = scape_init),
    do: %{
      id: via(scape_id),
      start: {__MODULE__, :start_link, [scape_init]},
      type: :supervisor,
      restart: :permanent,
      shutdown: 500
    }

  def start_link(%{id: scape_id} = scape_init),
    do:
      GenServer.start_link(
        __MODULE__,
        scape_init,
        name: via(scape_id)
      )
end
