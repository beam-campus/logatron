defmodule ReleaseRightPoc.CommandedApp do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  use Commanded.Application, otp_app: :release_right_poc
  @behaviour Application

  @impl true
  def init(config) do
    {:ok, config}
  end

  router(ReleaseRightPoc.Router)

  @impl true
  def start(_type, _args) do

    children = [
      ReleaseRightPoc.Projections,
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ReleaseRightPoc.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
