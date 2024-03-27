defmodule LogatronEdge.Facts do

  @moduledoc """
  LogatronEdge.Facts is a collection of all facts related to the edge used in the system.
  these facts are sent to the backend channel, where they are put on Logatron.PubSub.
  """


  def detached_v1, do: "edge:detached:v1"
  def attached_v1, do: "edge:attached:v1"



end
