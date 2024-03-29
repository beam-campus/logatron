defmodule LogatronWeb.MngStations.BrowseLive do
  use LogatronWeb, :live_view

  @moduledoc """
  LiveView module for the MngStations component.
  """

  alias Logatron.MngStations.Provider

  @impl true
  def mount(_params, _session, socket),
    do:
      {:ok,
       assign(
         socket,
         stations: Provider.get_stations_for_user(socket.assigns.current_user)
       )}
end
