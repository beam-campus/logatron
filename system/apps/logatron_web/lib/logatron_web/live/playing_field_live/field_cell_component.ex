defmodule LogatronWeb.PlayingFieldLive.FieldCellComponent do
  @moduledoc """
  The FieldCellComponent is used to render a single cell in the PlayingFieldGrid
  """

  use LogatronWeb, :live_component


  @impl true
  def update(assigns, socket) do
    {:ok, socket |> assign(assigns)}
  end

  






end
