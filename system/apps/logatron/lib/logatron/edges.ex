defmodule Logatron.Edges do
  @moduledoc """
  The Edges context.
  """

  import Ecto.Query, warn: false
  alias Logatron.Repo

  alias Logatron.Edges.Profile

  @doc """
  Returns the list of profiles.

  ## Examples

      iex> list_profiles()
      [%Profile{}, ...]

  """
  def list_profiles do
    Repo.all(Profile)
  end

  @doc """
  Gets a single profile.

  Raises `Ecto.NoResultsError` if the Profile does not exist.

  ## Examples

      iex> get_profile!(123)
      %Profile{}

      iex> get_profile!(456)
      ** (Ecto.NoResultsError)

  """
  def get_profile!(id), do: Repo.get!(Profile, id)

  @doc """
  Creates a profile.

  ## Examples

      iex> create_profile(%{field: value})
      {:ok, %Profile{}}

      iex> create_profile(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_profile(attrs \\ %{}) do
    %Profile{}
    |> Profile.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a profile.

  ## Examples

      iex> update_profile(profile, %{field: new_value})
      {:ok, %Profile{}}

      iex> update_profile(profile, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_profile(%Profile{} = profile, attrs) do
    profile
    |> Profile.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a profile.

  ## Examples

      iex> delete_profile(profile)
      {:ok, %Profile{}}

      iex> delete_profile(profile)
      {:error, %Ecto.Changeset{}}

  """
  def delete_profile(%Profile{} = profile) do
    Repo.delete(profile)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking profile changes.

  ## Examples

      iex> change_profile(profile)
      %Ecto.Changeset{data: %Profile{}}

  """
  def change_profile(%Profile{} = profile, attrs \\ %{}) do
    Profile.changeset(profile, attrs)
  end

  alias Logatron.Edges.Leaf

  @doc """
  Returns the list of leafs.

  ## Examples

      iex> list_leafs()
      [%Leaf{}, ...]

  """
  def list_leafs do
    Repo.all(Leaf)
  end

  @doc """
  Gets a single leaf.

  Raises `Ecto.NoResultsError` if the Leaf does not exist.

  ## Examples

      iex> get_leaf!(123)
      %Leaf{}

      iex> get_leaf!(456)
      ** (Ecto.NoResultsError)

  """
  def get_leaf!(id), do: Repo.get!(Leaf, id)

  @doc """
  Creates a leaf.

  ## Examples

      iex> create_leaf(%{field: value})
      {:ok, %Leaf{}}

      iex> create_leaf(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_leaf(attrs \\ %{}) do
    %Leaf{}
    |> Leaf.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a leaf.

  ## Examples

      iex> update_leaf(leaf, %{field: new_value})
      {:ok, %Leaf{}}

      iex> update_leaf(leaf, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_leaf(%Leaf{} = leaf, attrs) do
    leaf
    |> Leaf.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a leaf.

  ## Examples

      iex> delete_leaf(leaf)
      {:ok, %Leaf{}}

      iex> delete_leaf(leaf)
      {:error, %Ecto.Changeset{}}

  """
  def delete_leaf(%Leaf{} = leaf) do
    Repo.delete(leaf)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking leaf changes.

  ## Examples

      iex> change_leaf(leaf)
      %Ecto.Changeset{data: %Leaf{}}

  """
  def change_leaf(%Leaf{} = leaf, attrs \\ %{}) do
    Leaf.changeset(leaf, attrs)
  end

  
end
