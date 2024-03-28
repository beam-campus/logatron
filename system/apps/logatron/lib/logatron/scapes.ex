defmodule Logatron.Scapes do

  @moduledoc """
  The Scapes context.
  """

  alias Logatron.Scapes.Scape

  @doc """
  Returns the list of scapes.

  ## Examples

      iex> list_scapes()
      [%Scape{}, ...]

  """
  def list_scapes do
    Repo.all(Scape)
  end

  @doc """
  Gets a single scape.

  Raises `Ecto.NoResultsError` if the Scape does not exist.

  ## Examples

      iex> get_scape!(123)
      %Scape{}

      iex> get_scape!(456)
      ** (Ecto.NoResultsError)

  """
  def get_scape!(id), do: Repo.get!(Scape, id)

  @doc """
  Creates a scape.

  ## Examples

      iex> create_scape(%{field: value})
      {:ok, %Scape{}}

      iex> create_scape(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_scape(attrs \\ %{}) do
    %Scape{}
    |> Scape.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a scape.

  ## Examples

      iex> update_scape(scape, %{field: new_value})
      {:ok, %Scape{}}

      iex> update_scape(scape, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_scape(%Scape{} = scape, attrs) do
    scape
    |> Scape.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a scape.

  ## Examples

      iex> delete_scape(scape)
      {:ok, %Scape{}}

      iex> delete_scape(scape)
      {:error, %Ecto.Changeset{}}

  """
  def delete_scape(%Scape{} = scape) do
    Repo.delete(scape)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking scape changes.

  ## Examples

      iex> change_scape(scape)
      %Ecto.Changeset{data: %Scape{}}

  """
  def change_scape(%Scape{} = scape, attrs \\ %{}) do
    Scape.changeset(scape, attrs)
  end

  

end
