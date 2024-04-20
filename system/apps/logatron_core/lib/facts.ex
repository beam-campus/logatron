defmodule LogatronCore.Facts do
  @moduledoc """
  The Facts module is used to broadcast messages to all clients
  """
  ####### EDGE FACTS ########
  def edge_attached_v1,
    do: "edge_attached_v1"

  def edge_detached_v1,
    do: "edge_detached_v1"

  def edges_cache_updated_v1,
    do: "edges_cache_updated_v1"

  ######## SCAPE FACTS ########
  def scape_attached_v1,
    do: "scape_attached_v1"

  def initializing_scape_v1,
    do: "initializing_scape_v1"

  def scape_initialized_v1,
    do: "scape_initialized_v1"

  def scape_detached_v1,
    do: "scape_detached_v1"

  def scapes_cache_updated_v1,
    do: "scapes_cache_updated_v1"

  ######## REGION FACTS ########
  def initializing_region_v1,
    do: "initializing_region_v1"

  def region_initialized_v1,
    do: "region_initialized_v1"

  def region_detached_v1,
    do: "region_detached_v1"

  def regions_cache_updated_v1,
    do: "regions_cache_updated_v1"

  ######## FARM FACTS ########
  def initializing_farm_v1,
    do: "initializing_farm_v1"

  def farm_initialized_v1,
    do: "farm_initialized_v1"

  def farm_detached_v1,
    do: "farm_detached_v1"

  def farms_cache_updated_v1,
    do: "farms_cache_updated_v1"

  ######## BORN2DIED FACTS ########
  def initializing_born2died_v1,
    do: "initializing_born2died_v1"

  def born2died_initialized_v1,
    do: "born2died_initialized_v1"

  def born2died_detached_v1,
    do: "born2died_detached_v1"

  def born2died_state_changed_v1,
    do: "born2died_state_changed_v1"

  def born2died_died_v1,
    do: "born2died_died_v1"

  def born2dieds_cache_updated_v1,
    do: "born2dieds_cache_updated_v1"

  ############ PRESENCE FACTS ########
  def presence_changed_v1,
    do: "presence_changed_v1"
end
