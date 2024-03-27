defmodule Logatron.Repo.Migrations.CreateLeafs do
  use Ecto.Migration

  def change do
    create table(:leafs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :text
      add :api_key, :string
      add :pub_key, :text
      add :ip_address, :string
      add :profile_id, references(:profiles, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:leafs, [:profile_id])
  end
end
