defmodule LogatronWeb.ViewFieldsLive.FieldCard do
  use LogatronWeb, :live_component

  @moduledoc """
  The live component for the field card.
  """


  alias Lives.Service, as: Lives

  def get_lives(mng_farm_id),
    do: Lives.get_by_mng_farm_id(mng_farm_id)


  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
  end




end
