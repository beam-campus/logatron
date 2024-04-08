defmodule LogatronWeb.Dispatch.AnimalHandler do
  @moduledoc """
  The AnimalHandler is used to broadcast messages to all clients
  """

  require Logger

  alias LogatronCore.Facts
  alias Logatron.Born2Died.State

  @initializing_animal_v1 Facts.initializing_animal_v1()
  @animal_initialized_v1 Facts.animal_initialized_v1()

  def pub_initializing_animal_v1(payload, socket) do
    Logger.info("pub_initializing_animal_v1 #{inspect(payload)}")
    {:ok, animal_init} = State.from_map(payload["animal_init"])
    Phoenix.PubSub.broadcast(
      Logatron.PubSub,
      @initializing_animal_v1,
      {@initializing_animal_v1, animal_init}
    )
    {:noreply, socket}
  end



  def pub_animal_initialized_v1(payload, socket) do
    Logger.info("pub_animal_initialized_v1 #{inspect(payload)}")
    {:ok, animal_init} = State.from_map(payload["animal_init"])
    Phoenix.PubSub.broadcast(
      Logatron.PubSub,
      @animal_initialized_v1,
      {@animal_initialized_v1, animal_init}
    )
    {:noreply, socket}
  end






end
