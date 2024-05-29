defmodule RegisterTerminalTest do
  use ExUnit.Case
  doctest RegisterTerminal

  test "greets the world" do
    assert RegisterTerminal.hello() == :world
  end
end
