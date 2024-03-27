defmodule Logatron.EdgesTest do
  use Logatron.DataCase

  alias Logatron.Edges

  describe "profiles" do
    alias Logatron.Edges.Profile

    import Logatron.EdgesFixtures

    @invalid_attrs %{name: nil, description: nil, api_key: nil, pub_key: nil}

    test "list_profiles/0 returns all profiles" do
      profile = profile_fixture()
      assert Edges.list_profiles() == [profile]
    end

    test "get_profile!/1 returns the profile with given id" do
      profile = profile_fixture()
      assert Edges.get_profile!(profile.id) == profile
    end

    test "create_profile/1 with valid data creates a profile" do
      valid_attrs = %{name: "some name", description: "some description", api_key: "some api_key", pub_key: "some pub_key"}

      assert {:ok, %Profile{} = profile} = Edges.create_profile(valid_attrs)
      assert profile.name == "some name"
      assert profile.description == "some description"
      assert profile.api_key == "some api_key"
      assert profile.pub_key == "some pub_key"
    end

    test "create_profile/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Edges.create_profile(@invalid_attrs)
    end

    test "update_profile/2 with valid data updates the profile" do
      profile = profile_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description", api_key: "some updated api_key", pub_key: "some updated pub_key"}

      assert {:ok, %Profile{} = profile} = Edges.update_profile(profile, update_attrs)
      assert profile.name == "some updated name"
      assert profile.description == "some updated description"
      assert profile.api_key == "some updated api_key"
      assert profile.pub_key == "some updated pub_key"
    end

    test "update_profile/2 with invalid data returns error changeset" do
      profile = profile_fixture()
      assert {:error, %Ecto.Changeset{}} = Edges.update_profile(profile, @invalid_attrs)
      assert profile == Edges.get_profile!(profile.id)
    end

    test "delete_profile/1 deletes the profile" do
      profile = profile_fixture()
      assert {:ok, %Profile{}} = Edges.delete_profile(profile)
      assert_raise Ecto.NoResultsError, fn -> Edges.get_profile!(profile.id) end
    end

    test "change_profile/1 returns a profile changeset" do
      profile = profile_fixture()
      assert %Ecto.Changeset{} = Edges.change_profile(profile)
    end
  end

  describe "leafs" do
    alias Logatron.Edges.Leaf

    import Logatron.EdgesFixtures

    @invalid_attrs %{name: nil, description: nil, api_key: nil, pub_key: nil, ip_address: nil}

    test "list_leafs/0 returns all leafs" do
      leaf = leaf_fixture()
      assert Edges.list_leafs() == [leaf]
    end

    test "get_leaf!/1 returns the leaf with given id" do
      leaf = leaf_fixture()
      assert Edges.get_leaf!(leaf.id) == leaf
    end

    test "create_leaf/1 with valid data creates a leaf" do
      valid_attrs = %{name: "some name", description: "some description", api_key: "some api_key", pub_key: "some pub_key", ip_address: "some ip_address"}

      assert {:ok, %Leaf{} = leaf} = Edges.create_leaf(valid_attrs)
      assert leaf.name == "some name"
      assert leaf.description == "some description"
      assert leaf.api_key == "some api_key"
      assert leaf.pub_key == "some pub_key"
      assert leaf.ip_address == "some ip_address"
    end

    test "create_leaf/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Edges.create_leaf(@invalid_attrs)
    end

    test "update_leaf/2 with valid data updates the leaf" do
      leaf = leaf_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description", api_key: "some updated api_key", pub_key: "some updated pub_key", ip_address: "some updated ip_address"}

      assert {:ok, %Leaf{} = leaf} = Edges.update_leaf(leaf, update_attrs)
      assert leaf.name == "some updated name"
      assert leaf.description == "some updated description"
      assert leaf.api_key == "some updated api_key"
      assert leaf.pub_key == "some updated pub_key"
      assert leaf.ip_address == "some updated ip_address"
    end

    test "update_leaf/2 with invalid data returns error changeset" do
      leaf = leaf_fixture()
      assert {:error, %Ecto.Changeset{}} = Edges.update_leaf(leaf, @invalid_attrs)
      assert leaf == Edges.get_leaf!(leaf.id)
    end

    test "delete_leaf/1 deletes the leaf" do
      leaf = leaf_fixture()
      assert {:ok, %Leaf{}} = Edges.delete_leaf(leaf)
      assert_raise Ecto.NoResultsError, fn -> Edges.get_leaf!(leaf.id) end
    end

    test "change_leaf/1 returns a leaf changeset" do
      leaf = leaf_fixture()
      assert %Ecto.Changeset{} = Edges.change_leaf(leaf)
    end
  end

  describe "scapes" do
    alias Logatron.Edges.Scape

    import Logatron.EdgesFixtures

    @invalid_attrs %{name: nil, description: nil, overrides: nil}

    test "list_scapes/0 returns all scapes" do
      scape = scape_fixture()
      assert Edges.list_scapes() == [scape]
    end

    test "get_scape!/1 returns the scape with given id" do
      scape = scape_fixture()
      assert Edges.get_scape!(scape.id) == scape
    end

    test "create_scape/1 with valid data creates a scape" do
      valid_attrs = %{name: "some name", description: "some description", overrides: "some overrides"}

      assert {:ok, %Scape{} = scape} = Edges.create_scape(valid_attrs)
      assert scape.name == "some name"
      assert scape.description == "some description"
      assert scape.overrides == "some overrides"
    end

    test "create_scape/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Edges.create_scape(@invalid_attrs)
    end

    test "update_scape/2 with valid data updates the scape" do
      scape = scape_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description", overrides: "some updated overrides"}

      assert {:ok, %Scape{} = scape} = Edges.update_scape(scape, update_attrs)
      assert scape.name == "some updated name"
      assert scape.description == "some updated description"
      assert scape.overrides == "some updated overrides"
    end

    test "update_scape/2 with invalid data returns error changeset" do
      scape = scape_fixture()
      assert {:error, %Ecto.Changeset{}} = Edges.update_scape(scape, @invalid_attrs)
      assert scape == Edges.get_scape!(scape.id)
    end

    test "delete_scape/1 deletes the scape" do
      scape = scape_fixture()
      assert {:ok, %Scape{}} = Edges.delete_scape(scape)
      assert_raise Ecto.NoResultsError, fn -> Edges.get_scape!(scape.id) end
    end

    test "change_scape/1 returns a scape changeset" do
      scape = scape_fixture()
      assert %Ecto.Changeset{} = Edges.change_scape(scape)
    end
  end
end
