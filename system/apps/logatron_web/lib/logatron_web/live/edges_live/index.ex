defmodule LogatronWeb.EdgesLive.Index do
  use LogatronWeb, :live_view

  require Logger
  require Seconds

  alias Logatron.Edges.Server
  alias Phoenix.PubSub
  alias LogatronCore.Facts

  @edges_cache_updated_v1 Facts.edges_cache_updated_v1()

  # def refresh(_caller_state),
  #   do: Process.send(self(), :refresh, @refresh_seconds * 1_000)

  @impl true
  def mount(_params, _session, socket) do
    case connected?(socket) do
      true ->
        Logger.info("Connected")
        PubSub.subscribe(Logatron.PubSub, @edges_cache_updated_v1)

        {
          :ok,
          socket
          |> refresh_edges()
        }

      false ->
        Logger.info("Not connected")

        {
          :ok,
          socket
          |> refresh_edges()
        }
    end
  end

  @impl true
  def handle_info({@edges_cache_updated_v1, _payload}, socket),
    do: {
      :noreply,
      socket
      |> refresh_edges()
    }

  ####################### INTERNALS #######################

  defp refresh_edges(socket),
    do:
      socket
      |> assign(:edges, Server.get_all())
      |> assign(:now, DateTime.utc_now())
end
