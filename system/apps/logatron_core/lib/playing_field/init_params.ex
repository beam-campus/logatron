defmodule PlayingField.InitParams do
  use Ecto.Schema

  @moduledoc """
  PlayingField.InitParams is the struct that identifies the state of a PlayingField.
  """

  alias Logatron.Schema.Id

  alias PlayingField.InitParams

  require Logger

  @id_prefix "playing_field"

  @all_fields [
    :id,
    :edge_id,
    :scape_id,
    :region_id,
    :farm_id,
    :rows,
    :cols,
    :depth
  ]

  @derive {Jason.Encoder, only: @all_fields}
  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:edge_id, :string)
    field(:scape_id, :string)
    field(:region_id, :string)
    field(:farm_id, :string)
    field(:cols, :integer)
    field(:rows, :integer)
    field(:depth, :integer)
  end

  def from_mng_farm(depth, mng_farm_init) do
    id = Id.new(@id_prefix) |> Id.as_string()
    %{farm: farm} = mng_farm_init
    %InitParams{
      id: id,
      edge_id: mng_farm_init.edge_id,
      scape_id: mng_farm_init.scape_id,
      region_id: mng_farm_init.region_id,
      farm_id: mng_farm_init.farm_id,
      cols: farm.fields_def.x,
      rows: farm.fields_def.y,
      depth: depth
    }
  end


end
