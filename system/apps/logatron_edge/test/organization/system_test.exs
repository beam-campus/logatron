defmodule Organization.SystemTest do
  @moduledoc """
  This module tests the Logatron.Farm.System module.
  """
  use ExUnit.Case

  alias Organization.System

  @tag :ignore_test
  doctest Organization.System

  @tag :ignore_test
  test "that the Organization.System module exists" do
    assert is_list(Organization.System.module_info())
  end

end
