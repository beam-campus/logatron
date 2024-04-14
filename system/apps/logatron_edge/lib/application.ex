defmodule LogatronEdge.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc """
  LogatronEdge.Application is the main application for the Logatron Edge.
  """
  use Application

  require Logger


  @default_edge_id Logatron.Core.constants()[:edge_id]


  def edge_id,
    do: @default_edge_id

  @impl Application
  def start(_type, _args) do

    # {:ok, info} = Apis.IpInfoCache.refresh()

    edge_init = LogatronEdge.InitParams.enriched()

    Logger.info("\n\n\n Starting Logatron Edge with edge_init: #{inspect(edge_init)} \n\n\n")

    scape_init = LogatronEdge.Scape.InitParams.from_environment(edge_init.id)

    children = [
      {Finch, name: Logatron.Finch},
      {LogatronEdge.Client, edge_init},
      {Countries.Cache, name: Logatron.Countries},
      {LogatronEdge.Channel, scape_init},
      {LogatronEdge.Scape.System, scape_init}
    ]

    Supervisor.start_link(children,
      strategy: :one_for_one,
      name: __MODULE__
    )
  end

  def stop() do
    Supervisor.stop(__MODULE__)
  end
end
