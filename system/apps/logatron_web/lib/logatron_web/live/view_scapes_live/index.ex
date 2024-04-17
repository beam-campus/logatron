defmodule LogatronWeb.ViewScapesLive.Index do
  use LogatronWeb, :live_view

  @moduledoc """
  The live view for the scapes index.
  """

  alias Phoenix.PubSub

  alias Logatron.Scapes.{
    Scape,
    Region
  }

  require Logger

  alias LogatronCore.Facts

  @edges_cache_updated_v1 Facts.edges_cache_updated_v1()
  @scapes_cache_updated_v1 Facts.scapes_cache_updated_v1()

  @impl true
  def mount(_params, _session, socket) do
    case connected?(socket) do
      true ->
        Logger.info("Connected")
        PubSub.subscribe(Logatron.PubSub, @edges_cache_updated_v1)
        PubSub.subscribe(Logatron.PubSub, @scapes_cache_updated_v1)

        {:ok,
         socket
         |> assign(
           scapes: Logatron.Scapes.Server.get_all(),
           edges: Logatron.Edges.Server.get_all()
         )}

      false ->
        Logger.info("Not connected")

        {:ok,
         socket
         |> assign(
           scapes: [],
           edges: []
         )}
    end
  end

  ########## CALLBACKS ##########

  @impl true
  def handle_info({@scapes_cache_updated_v1, _payload}, socket) do
    {
      :noreply,
      socket
      |> assign(scapes: Logatron.Scapes.Server.get_all())
      |> put_flash(:success, "Scapes updated")
    }
  end

  @impl true
  def handle_info({@edges_cache_updated_v1, _payload}, socket) do
    {
      :noreply,
      socket
      |> assign(edges: Logatron.Edges.Server.get_all())
      |> put_flash(:success, "Edges updated")
    }
  end

  

end
