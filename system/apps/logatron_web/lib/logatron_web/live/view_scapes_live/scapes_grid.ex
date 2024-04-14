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

  def get_scapes_summary() do
    :scapes
    |> Cachex.stream!
    |> Stream.map(fn {:entry, _, _, _, scape} -> scape end)
    |> Enum.reduce(%{}, fn scape, acc -> Map.update(acc, scape.name, 1, & &1 + 1) end)
  end


  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
  end


end
