defmodule ReleaseRightPoc.Application do

  @moduledoc """
  The main application module for ReleaseRightPoc.
  """
  use Application, otp_app: :release_right_poc

  require Logger

  @impl true
  def start(_type, _args) do

    children = [
      {ReleaseRightPoc.CommandedApp, name: ReleaseRightPoc.CommandedApp},
      {ReleaseRightPoc.Projections, name: ReleaseRightPoc.Projections},

      {MngShippingAgents.CommandedApp, name: MngShippingAgents.CommandedApp},
      {MngShippingAgents.Projections, name: MngShippingAgents.Projections},

      {MngReleaseParties.CommandedApp, name: MngReleaseParties.CommandedApp},
      {MngReleaseParties.Projections, name: MngReleaseParties.Projections},

      

    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: ReleaseRightPoc.Supervisor)
  end


end
