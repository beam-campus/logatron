defmodule LogatronWeb.ViewScapesLive.ScapesGrid do
  use LogatronWeb, :live_component

  @moduledoc """
  The live component for the scapes grid.
  """

  alias Phoenix.PubSub

  alias Logatron.Scapes.{
    Scape,
    Region,
    Farm,
    Animal
  }

  @impl true
  def update(_assigns, socket) do
    {:ok, socket}
  end



end
