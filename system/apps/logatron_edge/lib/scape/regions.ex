defmodule LogatronEdge.Scape.Regions do
  @moduledoc """
  LogatronEdge.Scape.Regions is the top-level supervisor for the Logatron.MngScape subsystem.
  """
  use GenServer


  require Logger

  alias LogatronEdge.Channel

  ################ API ########################
  def start_region(region_init) do
    Logger.debug(" REGION ~> #{region_init.scape_id}.#{region_init.id} - #{region_init.nbr_of_farms} farms")

    Channel.initializing_region(region_init)

    DynamicSupervisor.start_child(
      via_sup(region_init.scape_id),
      {Logatron.Region.System, region_init}
    )

    Channel.region_initialized(region_init)
  end

  @doc """
  Returns the list of children supervised by this module
  """
  def which_children(key) do
    try do
      %{
        key: key,
        children:
          DynamicSupervisor.which_children(via_sup(key))
          |> Enum.reverse()
      }
    rescue
      e -> {:error, "which_children:#{inspect(e)}"}
    end
  end

  ######### CALLBACKS ############
  @impl GenServer
  def init(scape_init) do
    DynamicSupervisor.start_link(
      name: via_sup(scape_init.id),
      strategy: :one_for_one
    )

    {:ok, scape_init}
  end

  ############ PLUMBING ###################
  def to_name(key) when is_bitstring(key),
    do: "scape.regions.#{key}"

  def via_sup(key),
    do: Logatron.Registry.via_tuple({:regions_sup, to_name(key)})

  def via(key),
    do: Logatron.Registry.via_tuple({:regions, to_name(key)})

  def child_spec(scape_init),
    do: %{
      id: to_name(scape_init.id),
      start: {__MODULE__, :start_link, [scape_init]},
      type: :supervisor,
      restart: :permanent,
      shutdown: 500
    }

  def start_link(scape_init),
    do:
      GenServer.start_link(
        __MODULE__,
        scape_init,
        name: via(scape_init.id)
      )
end
