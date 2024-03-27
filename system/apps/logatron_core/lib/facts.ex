defmodule LogatronCore.Facts do
  @moduledoc """
  The Facts module is used to broadcast messages to all clients
  """

  def landscape_attached_v1,
    do: "landscape_attached_v1"

  def edge_attached_v1,
    do: "edge_attached_v1"

  def edge_detached_v1,
    do: "edge_detached_v1"
end
