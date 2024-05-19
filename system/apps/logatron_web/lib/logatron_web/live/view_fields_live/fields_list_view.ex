defmodule LogatronWeb.ViewFieldsLive.FieldsListView do
  use LogatronWeb, :live_component

  @moduledoc """
  The live component for the fields list view.
  """

  alias Fields.Service, as: Fields

  def get_fields(mng_farm_id),
    do: Fields.get_all_for_mng_farm_id(mng_farm_id)

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
  end
end
