defmodule Logatron.ScapeModelsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Logatron.ScapeModels` context.
  """

  @doc """
  Generate a scape_model.
  """
  def scape_model_fixture(attrs \\ %{}) do
    {:ok, scape_model} =
      attrs
      |> Enum.into(%{
        definition: "some definition",
        description: "some description",
        name: "some name"
      })
      |> Logatron.ScapeModels.create_scape_model()

    scape_model
  end
end
