defmodule LogatronEdge.Landscape.SystemTest do
  @moduledoc """
  This module tests the LogatronEdge.Landscape.System module.
  """
  use ExUnit.Case

  require Logger

  @test_landscape_params %{
    id: "farm_scape",
    nbr_of_regions: 5,
    min_area: 30_000,
    min_people: 10_000_000
  }

  @tag :test_landscape_system
  doctest LogatronEdge.Landscape.System

  describe "\n[~> Setup the Landscape.System test environment <~]\n" do
    setup %{} do
      case res = Logatron.Countries.Cache.start_link([]) do
        {:ok, cache} ->
          {:ok, cache}

        {:error, {:already_started, _}} ->
          Logger.info("Cache has already started")
      end
    end


    @tag :test_landscape_system
    test "\n[== Test that we can start the LogatronEdge.Landscape.System ==]" do
      res = LogatronEdge.Landscape.System.start_link(@test_landscape_params)

      case res do
        {:ok, _} ->
          assert true

        {:error, {:already_started, _}} ->
          assert true
      end

      Logger.debug("LogatronEdge.Landscape.System.start_link/1 returned => #{inspect(res)}")
    end

    @tag :test_landscape_system
    test "that the LogatronEdge.Landscape.System module exists" do
      assert is_list(LogatronEdge.Landscape.System.module_info())
    end

    @tag :test_landscape_system
    test "that we can start the Landscape.System for a particular landscape" do
      res =
        LogatronEdge.Landscape.System.start_link(@test_landscape_params)

      inspect(res)
    end
  end
end
