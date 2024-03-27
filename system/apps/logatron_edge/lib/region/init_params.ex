defmodule Logatron.Region.InitParams do
  @moduledoc """
  Logatron.Region.State is the struct that identifies the state of a Region.
  """

  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:nbr_of_farms, :integer)
  end

  def random(id) do
    %Logatron.Region.InitParams{
      id: id,
      nbr_of_farms: :rand.uniform(5)
    }
  end

  def default,
    do: %Logatron.Region.InitParams{
      id: "belgium",
      nbr_of_farms: 3
    }

end
