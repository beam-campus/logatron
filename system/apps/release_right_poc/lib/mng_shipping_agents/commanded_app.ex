defmodule MngShippingAgents.CommandedApp do
  use Commanded.Application, otp_app: :mng_shipping_agents
  @behaviour Application

  @impl true
  def init(config) do
    {:ok, config}
  end

  router(MngShippingAgents.Router)

  @impl true
  def start(_type, _args) do
    children = [
      MngShippingAgents.Projections,
    ]

    opts = [strategy: :one_for_one, name: MngShippingAgents.Supervisor]
    Supervisor.start_link(children, opts)
  end
  

end
