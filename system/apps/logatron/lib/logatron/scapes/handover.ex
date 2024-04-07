defmodule Logatron.Scapes.Handover do
  use Agent

  @moduledoc """
  Logatron.Scapes.Agent contains the GenAgent for the Agent.
  """

  alias Logatron.Scapes.Scape

  ###################  API  ###################
  def get(scape_id),
    do: Agent.get(via(scape_id), & &1)

  def save(scape),
    do: Agent.update(via(scape.id), & &1, fn _ -> scape end)

  ################### PLUMBING ###################
  def start_link(scape_init) do
    Agent.start_link(
      fn ->
        %Scape{
          id: scape_init.id,
          name: scape_init.name,
          status: "unknown",
        }
      end,
      name: via(scape_init.id)
    )
  end

  def via(id),
    do: Logatron.Registry.via_tuple({:scape_agent, to_name(id)})

  def to_name(key),
    do: "scapes.agent.#{key}"
end
