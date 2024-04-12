defmodule NordVpnCache do
  use GenServer

  @moduledoc """
  The NordvpnCache is used to cache the nordvpn data
  """

  require Logger
  require Req
  require Cachex

  @nordvpn_api_url "https://api.nordvpn.com/v1/servers"

  ############# API ################
  def get_overview(country),
    do:
      GenServer.call(
        __MODULE__,
        {:get_overview, country}
      )


  ############### CALLBACKS ###############
  @impl GenServer
  def handle_call({:get_overview, country}, _from, state) do
    overview =
      state
      |> Enum.map(fn server ->
        %{
          locations: server["locations"],
          id: server["id"],
          name: server["name"],
          hostname: server["hostname"],
          load: server["load"],
          status: server["status"],
          tech_names: server["technologies"] |> Enum.map(& &1["name"])
        }
      end)
      |> Enum.filter(&String.contains?(&1.name, country))

    {:reply, overview, state}
  end


  @impl GenServer
  def init(_args) do
    state = Req.get!(@nordvpn_api_url).body()
    {:ok, state}
  end

  ################# PLUMBING ####################
  def child_spec(),
    do: %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :worker,
      restart: :permanent
    }

  def start_link(),
    do:
      GenServer.start_link(
        __MODULE__,
        [],
        name: __MODULE__
      )
end
