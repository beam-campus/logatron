defmodule LogatronCore.Facts do
  @moduledoc """
  The Facts module is used to broadcast messages to all clients
  """

  def edge_attached_v1,
    do: "edge_attached_v1"

  def edge_detached_v1,
    do: "edge_detached_v1"

  def scape_attached_v1,
    do: "scape_attached_v1"

  def initializing_scape_v1,
    do: "initializing_scape_v1"

  def scape_initialized_v1,
    do: "scape_initialized_v1"

  def initializing_region_v1,
    do: "initializing_region_v1"

  def region_initialized_v1,
    do: "region_initialized_v1"

    def initializing_farm_v1,
    do: "initializing_farm_v1"

  def farm_initialized_v1,
    do: "farm_initialized_v1"

  def initializing_animal_v1,
    do: "initializing_animal_v1"

  def animal_initialized_v1,
    do: "animal_initialized_v1"

    

  def presence_changed_v1,
    do: "presence_changed_v1"
end
