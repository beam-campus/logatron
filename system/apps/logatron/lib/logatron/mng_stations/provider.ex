defmodule Logatron.MngStations.Provider do

  @moduledoc """
  Domain module for the MngStations component.
  """

def get_stations_for_user(user) do
  Logatron.MngStations.Repo.db()
  |> Enum.filter(fn station -> station.user_email == user.email end)
end




end
