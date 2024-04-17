defmodule LogatronWeb.Dispatch.Born2DiedHandler do
  @moduledoc """
  The AnimalHandler is used to broadcast messages to all clients
  """

  require Logger

  alias LogatronCore.Facts
  alias Logatron.Born2Died.State
  alias Logatron.Born2Dieds.Server, as: Born2DiedsCache


  @initializing_born2died_v1 Facts.initializing_born2died_v1()
  @born2died_initialized_v1 Facts.born2died_initialized_v1()


  def pub_initializing_animal_v1(payload, socket) do
    Logger.info("pub_initializing_animal_v1 #{inspect(payload)}")
    {:ok, animal_init} = State.from_map(payload["born2died_init"])

    Born2DiedsCache.save(animal_init)

    Phoenix.PubSub.broadcast(
      Logatron.PubSub,
      @initializing_born2died_v1,
      {@initializing_born2died_v1, animal_init}
    )
    {:noreply, socket}
  end



  def pub_animal_initialized_v1(payload, socket) do
    Logger.info("pub_animal_initialized_v1 #{inspect(payload)}")
    {:ok, animal_init} = State.from_map(payload["born2died_init"])
    Phoenix.PubSub.broadcast(
      Logatron.PubSub,
      @born2died_initialized_v1,
      {@born2died_initialized_v1, animal_init}
    )
    {:noreply, socket}
  end






end
