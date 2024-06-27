defmodule ReplTests do
  @moduledoc """
  This module is used to test the REPL commands.
  """

  use GenServer

  alias ReleaseRightPoc.CommandedApp,
    as: App

  alias ReleaseRightPoc.InitializeRRPoc.Cmd,
    as: InitializeRRPoc

  alias Commanded.UUID,
    as: UUID

    require Logger

  # alias ReleaseRightPoc.InitializeRRPoc.Evt,
  #   as: ReleaseRightPocInitialized

  @impl true
  def init(nbr) do
    {:ok, nbr}
  end





  def send_initialize_poc(usr \\ "raf", count \\ 1000) do
    for _c <- 1..count  do
      GenServer.cast(__MODULE__, {:initialize_poc, usr})
    end
  end

  def send_initialize_by(usr \\ "raf") do
    Process.sleep(100)

    command = %InitializeRRPoc{
      root_id: "rr_poc_#{usr}_#{UUID.uuid4()}",
      terminal_id: "terminal_#{usr}_#{UUID.uuid4()}",
      container_id: "container_#{usr}_#{UUID.uuid4()}"
    }

    case App.start_link() do
      {:ok, _} ->
        IO.puts("App started")
        App.dispatch(command)

      {:error, {:already_started, pid}} ->
        IO.puts("App already started with pid #{inspect(pid)}")
        App.dispatch(command)

      {:error, _} ->
        IO.puts("App failed to start")
    end
  end



  @impl true
  def handle_cast({:initialize_poc, usr}, nbr) do
    Logger.alert("Initializing Release Right POC for #{usr}")
    send_initialize_by(usr)
    {:noreply, nbr}
  end

  def start(nbr \\ 1000) do
    ReleaseRightPoc.Projections.start_link([])
    GenServer.start_link(__MODULE__, nbr, name: __MODULE__)
  end
end
