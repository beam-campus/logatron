defmodule Logatron.MngHerd.State do
  use Ecto.Schema
  import Logatron.Limits
  alias Logatron.Schema.Id

  @moduledoc """
  Documentation for `Logatron.MngHerd.State`.
  """

  @prefix "mng-herd"

  @primary_key false
  embedded_schema do
    field :id, :string
    field :edge_id, :string
    field :size, :integer
    embeds_one(:map, Logatron.Schema.Vector)
  end

  def random(edge_id, map) do
    %Logatron.MngHerd.State{
      id: Id.new(@prefix) |> Id.as_string(),
      edge_id: edge_id,
      size: random_nbr_lives(),
      map: map
    }
  end

end
