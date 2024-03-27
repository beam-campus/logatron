defmodule Logatron.MngFarm.InitParams do
  @moduledoc """
  Logatron.MngFarm.InitParams is the struct that identifies the state of a Farm.
  """
  use Ecto.Schema

  @id_prefix "mng_farm"

  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:nbr_of_lives, :integer)
    embeds_one(:farm, Logatron.Schema.Farm)
  end

  def default,
    do: %Logatron.MngFarm.InitParams{
      id: "mng_farm-0000-0000-0000-000000000000",
      nbr_of_lives: 10
    }

  def random(farm),
    do: %Logatron.MngFarm.InitParams{
      id: Logatron.Schema.Id.new(@id_prefix) |> Logatron.Schema.Id.as_string(),
      nbr_of_lives: Logatron.Limits.random_nbr_lives(),
      farm: farm
    }
end
