defmodule Logatron.ScapeModelsTest do
  use Logatron.DataCase

  alias Logatron.ScapeModels

  describe "scape_models" do
    alias Logatron.ScapeModels.ScapeModel

    import Logatron.ScapeModelsFixtures

    @invalid_attrs %{name: nil, description: nil, definition: nil}

    test "list_scape_models/0 returns all scape_models" do
      scape_model = scape_model_fixture()
      assert ScapeModels.list_scape_models() == [scape_model]
    end

    test "get_scape_model!/1 returns the scape_model with given id" do
      scape_model = scape_model_fixture()
      assert ScapeModels.get_scape_model!(scape_model.id) == scape_model
    end

    test "create_scape_model/1 with valid data creates a scape_model" do
      valid_attrs = %{name: "some name", description: "some description", definition: "some definition"}

      assert {:ok, %ScapeModel{} = scape_model} = ScapeModels.create_scape_model(valid_attrs)
      assert scape_model.name == "some name"
      assert scape_model.description == "some description"
      assert scape_model.definition == "some definition"
    end

    test "create_scape_model/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ScapeModels.create_scape_model(@invalid_attrs)
    end

    test "update_scape_model/2 with valid data updates the scape_model" do
      scape_model = scape_model_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description", definition: "some updated definition"}

      assert {:ok, %ScapeModel{} = scape_model} = ScapeModels.update_scape_model(scape_model, update_attrs)
      assert scape_model.name == "some updated name"
      assert scape_model.description == "some updated description"
      assert scape_model.definition == "some updated definition"
    end

    test "update_scape_model/2 with invalid data returns error changeset" do
      scape_model = scape_model_fixture()
      assert {:error, %Ecto.Changeset{}} = ScapeModels.update_scape_model(scape_model, @invalid_attrs)
      assert scape_model == ScapeModels.get_scape_model!(scape_model.id)
    end

    test "delete_scape_model/1 deletes the scape_model" do
      scape_model = scape_model_fixture()
      assert {:ok, %ScapeModel{}} = ScapeModels.delete_scape_model(scape_model)
      assert_raise Ecto.NoResultsError, fn -> ScapeModels.get_scape_model!(scape_model.id) end
    end

    test "change_scape_model/1 returns a scape_model changeset" do
      scape_model = scape_model_fixture()
      assert %Ecto.Changeset{} = ScapeModels.change_scape_model(scape_model)
    end
  end
end
