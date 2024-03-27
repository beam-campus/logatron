defmodule Logatron.ScapeModels do
  @moduledoc """
  The ScapeModels context.
  """

  import Ecto.Query, warn: false
  alias Logatron.Repo

  alias Logatron.ScapeModels.ScapeModel

  @doc """
  Returns the list of scape_models.

  ## Examples

      iex> list_scape_models()
      [%ScapeModel{}, ...]

  """
  def list_scape_models do
    Repo.all(ScapeModel)
  end

  @doc """
  Gets a single scape_model.

  Raises `Ecto.NoResultsError` if the Scape model does not exist.

  ## Examples

      iex> get_scape_model!(123)
      %ScapeModel{}

      iex> get_scape_model!(456)
      ** (Ecto.NoResultsError)

  """
  def get_scape_model!(id), do: Repo.get!(ScapeModel, id)

  @doc """
  Creates a scape_model.

  ## Examples

      iex> create_scape_model(%{field: value})
      {:ok, %ScapeModel{}}

      iex> create_scape_model(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_scape_model(attrs \\ %{}) do
    %ScapeModel{}
    |> ScapeModel.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a scape_model.

  ## Examples

      iex> update_scape_model(scape_model, %{field: new_value})
      {:ok, %ScapeModel{}}

      iex> update_scape_model(scape_model, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_scape_model(%ScapeModel{} = scape_model, attrs) do
    scape_model
    |> ScapeModel.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a scape_model.

  ## Examples

      iex> delete_scape_model(scape_model)
      {:ok, %ScapeModel{}}

      iex> delete_scape_model(scape_model)
      {:error, %Ecto.Changeset{}}

  """
  def delete_scape_model(%ScapeModel{} = scape_model) do
    Repo.delete(scape_model)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking scape_model changes.

  ## Examples

      iex> change_scape_model(scape_model)
      %Ecto.Changeset{data: %ScapeModel{}}

  """
  def change_scape_model(%ScapeModel{} = scape_model, attrs \\ %{}) do
    ScapeModel.changeset(scape_model, attrs)
  end
end
