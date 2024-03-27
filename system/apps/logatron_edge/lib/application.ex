defmodule LogatronEdge.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc """
  LogatronEdge.Application is the main application for the Logatron Edge.
  """
  use Application

  @default_edge_id Logatron.Core.constants()[:edge_id]

  def edge_id,
    do: @default_edge_id

  @impl Application
  def start(_type, _args) do

    landscape_init = LogatronEdge.Landscape.InitParams.europe()
    children = [
      {Finch, name: Logatron.Finch},
      {LogatronEdge.Client, landscape_init},
      {Countries.Cache, name: Logatron.Countries},
      {LogatronEdge.Landscape.System, landscape_init}
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
