defmodule EnvVars do
  @moduledoc """
  The EnvVars module is used to define environment variables
  """

  def logatron_edge_api_key,
    do: "LOGATRON_EDGE_API_KEY"

  def logatron_edge_max_regions,
    do: "LOGATRON_EDGE_MAX_REGIONS"

  def logatron_edge_max_farms,
    do: "LOGATRON_EDGE_MAX_FARMS"

  def logatron_edge_max_animals,
    do: "LOGATRON_EDGE_MAX_ANIMALS"
end
