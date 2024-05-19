defmodule Edge.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc """
    Edge.Application is the main application for the Logatron Edge.
  """
  use Application

  require Logger

  alias Edge.Init, as: EdgeInit
  alias Scape.Init, as: ScapeInit


  @default_edge_id Logatron.Core.constants()[:edge_id]


  def edge_id,
    do: @default_edge_id

  @impl Application
  def start(_type, _args) do

    # {:ok, info} = Apis.IpInfoCache.refresh()

    edge_init = EdgeInit.enriched()

    Logger.info("\n\n\n Starting Logatron Edge with edge_init: #{inspect(edge_init)} \n\n\n")

    scape_init = ScapeInit.from_environment(edge_init.id)

    children = [
      {Edge.Registry, name: Edge.Registry},
      {Edge.Client, edge_init}, # 
      {Phoenix.PubSub, name: EdgePubSub},
      {Finch, name: Logatron.Finch},
      {Countries.Cache, name: Logatron.Countries},
      {Edge.Emitter, scape_init},
      {Scape.System, scape_init}
    ]

    Supervisor.start_link(
      children,
      name: __MODULE__,
      strategy: :one_for_one
    )
    # stop(scape_init)
  end

  @impl Application
  def stop(scape_init) do
    Scape.System.terminate(:normal, scape_init)
    Supervisor.stop(__MODULE__)
  end
end
