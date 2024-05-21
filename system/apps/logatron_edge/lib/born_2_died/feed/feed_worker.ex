defmodule Born2Died.FeedWorker do
  use GenServer, restart: :transient

  @moduledoc """
  Born2Died.FeedWorker is a GenServer that manages the feed of a life
  """

  require Logger

  alias Born2Died.State, as: LifeState

  ############# CALLBACKS #############

  @impl GenServer
  def init(state) do
    Logger.info("feed.worker: #{Colors.born2died_theme(self())}")
    {:ok, state}
  end

  ############# PLUMBING ############
  def via(life_init_id),
    do: Edge.Registry.via_tuple({:feed_worker, to_name(life_init_id)})

  def to_name(life_init_id),
    do: "born2died.feed_worker.#{life_init_id}"

  def child_spec(%LifeState{} = life_init),
    do: %{
      id: to_name(life_init.id),
      start: {__MODULE__, :start_link, [life_init]},
      type: :worker,
      restart: :transient
    }

  def start_link(%LifeState{} = life_init),
    do:
      GenServer.start_link(
        __MODULE__,
        life_init,
        name: via(life_init.id)
      )
end