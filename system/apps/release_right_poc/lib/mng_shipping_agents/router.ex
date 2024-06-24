defmodule MngShippingAgents.Router do
  @moduledoc """
  The router for the MngShippingAgents context.
  """

  use Commanded.Commands.Router

  alias MngShippingAgents.Initialize.Cmd,  as: Initialize


  alias MngShippingAgents.Handler,   as: Handler

  alias MngShippingAgents.Aggregate,    as: Aggregate

  dispatch(Initialize,
    to: Handler,
    aggregate: Aggregate,
    identity: :root_id
  )
end
