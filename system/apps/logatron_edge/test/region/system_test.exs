defmodule Logatron.Region.SystemTest do
  use ExUnit.Case


  @test_landscape

  @tag :ignore_test
  doctest Logatron.Region.System

  alias Logatron.Region.System

  @tag :ignore_test
  test "that the Logatron.Region.System module exists" do
    assert is_list(Logatron.Region.System.module_info())
  end


  @tag :ignore_test
  test "that we can start a Logatron.Region.System" do
    landscape = @test_landscape
    res =  Logatron.Region.System.start_link(nil,nil)
    case res do
      {:ok, pid} ->
        assert pid != nil
        assert Process.alive?(pid)
      {:error, {:already_started, pid}} ->
        assert pid != nil
        assert Process.alive?(pid)
    end
  end


end
