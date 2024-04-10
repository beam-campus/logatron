defmodule LogatronWeb.ViewScapesLive.BreadCrumbsBar do
  use LogatronWeb, :live_component

  @moduledoc """
  The live component for the bread crumbs bar.
  """

  alias Phoenix.PubSub

  alias Logatron.Scapes.{
    Scape,
    Region,
    Farm,
    Animal
  }

  @impl true
  def update(assigns, socket) do
    {:ok, socket}
  end

  





end
