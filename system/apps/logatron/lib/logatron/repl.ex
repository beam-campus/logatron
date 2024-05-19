defmodule Repl do
  @moduledoc """
  Logatron.ReplInspector contains the REPL inspector.
  """

  alias Farms.Service, as: Farms
  alias Lives.Service, as: Lives

  require Logger

  def get_lives_for_random_mng_farm_id() do

    [%{id: mng_farm_id} = _mng_farm | _rest] =
      Farms.get_all()
      |> Enum.take(1)

    Logger.info("get_lives_for_random_mng_farm_id: mng_farm_id: #{mng_farm_id}")

    Lives.get_by_mng_farm_id(mng_farm_id)
  end

  def get_all_farms() do
    Farms.get_all()
  end

  def get_all_lives() do
    Lives.get_all()
  end

  
end
