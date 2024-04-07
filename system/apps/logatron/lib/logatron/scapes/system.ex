defmodule Logatron.Scapes.System do
  use GenServer

  @moduledoc """
  Logatron.Scapes.System contains the GenServer for the System.
  """

  ###################  PLUMBING  ###################

  def init(scape_init) do
    Supervisor.start_link(
      [
        {Logatron.Scapes.Handover, [scape_init]},
        {Logatron.Scapes.Server, [scape_init]}
      ],
      strategy: :one_for_one,
      name: via_sup(scape_init.id)
    )

    {:ok, scape_init}
  end

  def child_spec(scape_init) do
    %{
      id: to_name(scape_init.id),
      start: {__MODULE__, :start_link, [scape_init]},
      type: :worker,
      restart: :permanent,
    }
  end

  def to_name(key) when is_bitstring(key),
    do: "scape.system.#{key}"

  def via(key),
    do: Logatron.Registry.via_tuple({:scape_system, to_name(key)})

  def via_sup(key),
    do: Logatron.Registry.via_tuple({:scape_sup, to_name(key)})
end
