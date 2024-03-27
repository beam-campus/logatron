defmodule Logatron.Schema.Stable do
  use Ecto.Schema

  schema "stables" do
    belongs_to :farm, Logatron.Schema.Farm
    has_many :robots, Logatron.Schema.Robot
  end
end
