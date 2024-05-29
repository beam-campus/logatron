defmodule RegisterOperatorTest do
  use ExUnit.Case
  doctest RegisterOperator

  test "greets the world" do
    assert RegisterOperator.hello() == :world
  end
end
