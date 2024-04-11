defmodule Logatron.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Logatron.Repo,
      Logatron.Edges.Cache,
      {DNSCluster, query: Application.get_env(:logatron, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Logatron.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Logatron.Finch}
      # Start a worker by calling: Logatron.Worker.start_link(arg)
      # {Logatron.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Logatron.Supervisor)
  end
end
