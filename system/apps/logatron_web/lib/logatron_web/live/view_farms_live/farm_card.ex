defmodule LogatronWeb.ViewFarmsLive.FarmCard do
  use LogatronWeb, :live_component

  @moduledoc """
  The live component for the farm card.
  """

  alias MngFarm.Init, as: FarmInit



  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
  end




end