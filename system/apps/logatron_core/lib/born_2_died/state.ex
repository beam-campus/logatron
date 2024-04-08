defmodule Logatron.Born2Died.State do
  use Ecto.Schema

  @moduledoc """
  The Life State are the parameters
  that are used as the state structure for a Life Worker
  """

  import Ecto.Changeset

  alias Logatron.Schema.{
    Id,
    Vector,
    Vitals,
    Life
  }

  defguard is_born_2_died_state(state)
           when is_struct(state, __MODULE__)

  @id_prefix "born2died"

  @status %{
    unknown: 0,
    initialized: 1,
    alive: 2,
    infected: 4,
    pregnant: 8,
    dead: 16,
    in_heat: 32,
    in_cool: 64,
    wounded: 128
  }

  @all_fields [
    :id,
    :edge_id,
    :scape_id,
    :region_id,
    :farm_id,
    :field_id,
    :ticks,
    :status,
    :life,
    :pos,
    :vitals
  ]

  @flat_fields [
    :id,
    :edge_id,
    :scape_id,
    :region_id,
    :farm_id,
    :field_id,
    :ticks,
    :status
  ]

  def status, do: @status

  @derive {Jason.Encoder, only: @all_fields}
  @primary_key false
  embedded_schema do
    field(:id, :string)
    field(:edge_id, :string)
    field(:scape_id, :string)
    field(:region_id, :string)
    field(:farm_id, :string)
    field(:field_id, :string)
    field(:ticks, :integer)
    field(:status, :integer)
    embeds_one(:life, Life)
    embeds_one(:pos, Vector)
    embeds_one(:vitals, Vitals)
  end

  def random(edge_id, scape_id, region_id, farm_id, %{x: max_x, y: max_y, z: z} = _vector, life) do
    %Logatron.Born2Died.State{
      id: Id.new(@id_prefix) |> Id.as_string(),
      edge_id: edge_id,
      scape_id: scape_id,
      region_id: region_id,
      farm_id: farm_id,
      field_id: Id.new("field", to_string(z)) |> Id.as_string(),
      life: life,
      pos: Vector.random(max_x, max_y, 1),
      vitals: Vitals.random(),
      ticks: 0,
      status: 0
    }
  end

  def default(edge_id, scape_id, region_id, farm_id) do
    %Logatron.Born2Died.State{
      id: Id.new(@id_prefix) |> Id.as_string(),
      edge_id: edge_id,
      scape_id: scape_id,
      region_id: region_id,
      farm_id: farm_id,
      field_id: Id.new("field", to_string(1)) |> Id.as_string(),
      life: Life.random(),
      pos: Vector.random(1_000, 1_000, 1),
      vitals: Vitals.random(),
      ticks: 0,
      status: 0
    }
  end

  def from_life(life, edge_id, scape_id, region_id, farm_id) do
    %Logatron.Born2Died.State{
      id: Id.new(@id_prefix) |> Id.as_string(),
      edge_id: edge_id,
      scape_id: scape_id,
      region_id: region_id,
      farm_id: farm_id,
      field_id: Id.new("field", to_string(1)) |> Id.as_string(),
      life: life,
      pos: Vector.random(1_000, 1_000, 1),
      vitals: Vitals.random(),
      ticks: 0,
      status: 0
    }
  end

  def changeset(state, args) when is_map(args) do
    state
    |> cast(args, @flat_fields)
    |> cast_embed(:life, required: true)
    |> cast_embed(:pos, required: true)
    |> cast_embed(:vitals, required: true)
    |> validate_required(@all_fields)
  end

  def from_map(map) when is_map(map) do
    case(changeset(%Logatron.Born2Died.State{}, map)) do
      %{valid?: true} = changeset ->
        state =
          changeset
          |> Ecto.Changeset.apply_changes()

        {:ok, state}

      changeset ->
        {:error, changeset}
    end
  end

  ############## IMPLEMENTATIONS ##############
  defimpl String.Chars, for: __MODULE__ do
    def to_string(s) do
      "\n\n [#{__MODULE__}]\n" <>
        "#{s.life}" <>
        "#{s.vitals}\n\n"
    end
  end
end
