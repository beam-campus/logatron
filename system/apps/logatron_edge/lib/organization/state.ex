defmodule Logatron.Organization.State do
  @moduledoc """
  Logatron.Organization.State is a GenServer that holds the state of a Farm.
  """
  use Ecto.Schema


  embedded_schema() do
    field(:aggregate_id, :string)
    embeds_one(:farm, Schema.Farm)
  end


end
