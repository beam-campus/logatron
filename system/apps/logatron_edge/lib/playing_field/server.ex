defmodule PlayingField.Server do
  use GenServer

  @moduledoc """
  The System module is used to manage the PlayingField subsystem
  """

  alias PlayingField.InitParams, as: FieldParams
  alias PlayingFieldCell.InitParams, as: CellParams

  require Logger

  ################### CALLBACKS ###################
  @impl GenServer
  def init(field_init) do
    DynamicSupervisor.start_link(
      name: via_sup(field_init.id),
      strategy: :one_for_one
    )
    {:ok, generate_cells(field_init)}
  end

  #################### INTERNAL ###################
  defp generate_cells(field_init) do
    {cols, rows, depth} = {field_init.cols, field_init.rows, field_init.depth}
    for x <- 1..cols,
        y <- 1..rows,
        z <- 1..depth do
      DynamicSupervisor.start_child(
        via_sup(field_init.id),
        {PlayingFieldCell.Server,
         CellParams.from_field_init(
           field_init,
           x,
           y,
           z
         )}
      )
    end
    Logger.info("#{depth} fields of [#{cols}x#{rows}] generated")
    field_init
  end

  ################### PLUMBING ###################
  defp to_name(field_id),
    do: "playing_field.system.#{field_id}"

  def via(field_id),
    do: Logatron.Registry.via_tuple({:playing_field_sys, to_name(field_id)})

  def via_sup(field_id),
    do: Logatron.Registry.via_tuple({:playing_field_sup, to_name(field_id)})

  def start_link(field_init) do
    GenServer.start_link(
      __MODULE__,
      field_init,
      name: via(field_init.id)
    )
  end
end
