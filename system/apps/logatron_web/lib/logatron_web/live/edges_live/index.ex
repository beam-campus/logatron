defmodule LogatronWeb.EdgesLive.Index do
  use LogatronWeb, :live_view

  require Logger
  require Seconds

  alias Logatron.Edges.Server, as: EdgesCache
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
        PubSub.subscribe(Logatron.PubSub, "edges_cache_updated_v1")

        {
          :ok,
          socket
          |> assign(
            edges: EdgesCache.get_all(),
            now: DateTime.utc_now()
          )
        }

      false ->
        Logger.info("Not connected")

        {
          :ok,
          socket
          |> assign(
            edges: [],
            now: DateTime.utc_now()
          )
        }
    end
  end

  # @impl true
  # def handle_info({@edges_cache_updated_v1, _payload}, socket) do

  #   {
  #     :noreply,
  #     socket
  #     |> assign(
  #       edges: EdgesCache.get_all(),
  #       now: DateTime.utc_now()
  #     )
  #   }
  # end

  @impl true
  def handle_info(msg, socket) do
    Logger.error("Unhandled message: #{inspect(msg)}")
    {:noreply, socket}
  end

end
