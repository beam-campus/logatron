defmodule Logatron.MngFarm.SystemTest do
  @moduledoc """
  This module tests the Logatron.Farm.System module.
  """
  use ExUnit.Case

  alias Logatron.MngFarm.System

  @tag :ignore_test
  doctest Logatron.MngFarm.System

  @tag :ignore_test
  test "that the Logatron.MngFarm.System module exists" do
    assert is_list(Logatron.MngFarm.System.module_info())
  end

end
