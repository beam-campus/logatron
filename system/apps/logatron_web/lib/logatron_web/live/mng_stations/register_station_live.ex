defmodule LogatronWeb.MngStations.RegisterStationLive do
  use LogatronWeb, :live_view

  @moduledoc """
  LiveView module for the RegisterStation component.
  """

  alias Logatron.MngStations.Schema.Station

  def mount(_params, _session, socket),
    do:
      {:ok,
       assign(
         socket,
         form: to_form(Station.change_set(%Station{}, %{}))
       )}


end
