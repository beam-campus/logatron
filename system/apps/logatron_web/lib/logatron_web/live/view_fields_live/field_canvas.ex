## Reference https://www.petecorey.com/blog/2019/09/02/animating-a-canvas-with-phoenix-liveview/
defmodule LogatronWeb.ViewFieldsLive.FieldCanvas do
  use LogatronWeb, :live_component

  @moduledoc """
  The live component for the field canvas.
  """

  alias Lives.Service, as: Lives

  def get_lives(mng_farm_id),
    do: Lives.get_by_mng_farm_id(mng_farm_id)

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> update(:lives, get_lives(assigns.mng_farm_id))
    }
  end


  









end
