defmodule Logatron.EdgesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Logatron.Edges` context.
  """

  @doc """
  Generate a profile.
  """
  def profile_fixture(attrs \\ %{}) do
    {:ok, profile} =
      attrs
      |> Enum.into(%{
        api_key: "some api_key",
        description: "some description",
        name: "some name",
        pub_key: "some pub_key"
      })
      |> Logatron.Edges.create_profile()

    profile
  end

  @doc """
  Generate a leaf.
  """
  def leaf_fixture(attrs \\ %{}) do
    {:ok, leaf} =
      attrs
      |> Enum.into(%{
        api_key: "some api_key",
        description: "some description",
        ip_address: "some ip_address",
        name: "some name",
        pub_key: "some pub_key"
      })
      |> Logatron.Edges.create_leaf()

    leaf
  end

  @doc """
  Generate a scape.
  """
  def scape_fixture(attrs \\ %{}) do
    {:ok, scape} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        overrides: "some overrides"
      })
      |> Logatron.Edges.create_scape()

    scape
  end
end
