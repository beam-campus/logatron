defmodule EnvVars do
  @moduledoc """
  The EnvVars module is used to define environment variables
  """

  def logatron_edge_api_key,
    do: "LOGATRON_EDGE_API_KEY"

  def logatron_edge_scape_id,
    do: "LOGATRON_SCAPE_ID"

  def logatron_edge_scape_name,
    do: "LOGATRON_SCAPE_NAME"

  def logatron_edge_scape_select_from,
    do: "LOGATRON_CONTINENTS"

  # def logatron_edge_max_countries,
  #   do: "LOGATRON_MAX_COUNTRIES_PER_CONTINENT"

  def logatron_edge_scape_min_area,
    do: "LOGATRON_MIN_COUNTRY_AREA_KM2"

  def logatron_edge_scape_min_people,
    do: "LOGATRON_MIN_COUNTRY_POPULATION"

  def logatron_edge_max_farms,
    do: "LOGATRON_MAX_FARMS_PER_COUNTRY"

  def logatron_edge_max_animals,
    do: "LOGATRON_INIT_ANIMALS_PER_FARM"

  def logatron_edge_scape_nbr_of_countries,
    do: "LOGATRON_MAX_COUNTRIES"
    
end
