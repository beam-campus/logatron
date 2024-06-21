defmodule ReleaseRightPoc.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Commanded.Application, otp_app: :release_right_poc


  def init(config) do
    {:ok, config}
  end

  # def start(_type, _args) do
  #   children = [
  #     # Starts a worker by calling: ReleaseRightPoc.Worker.start_link(arg)
  #     # {ReleaseRightPoc.Worker, arg}
  #   ]

  #   # See https://hexdocs.pm/elixir/Supervisor.html
  #   # for other strategies and supported options
  #   opts = [strategy: :one_for_one, name: ReleaseRightPoc.Supervisor]
  #   Supervisor.start_link(children, opts)
  # end
end
