defmodule LogatronEdge.ChannelTest do
  use ExUnit.Case

  @moduledoc """
  Tests for the LogatronEdge.Channel module.
  """

  @tag :ignore_test
  doctest LogatronEdge.Channel

  @tag :ignore_test
  test "that the LogatronEdge.Channel module exists" do
    assert is_list(LogatronEdge.Channel.module_info())
  end
end
