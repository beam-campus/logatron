defmodule Logatron.Repo.Migrations.CreateScapes do
  use Ecto.Migration

  def change do
    create table(:scapes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :text
      add :overrides, :text
      add :leaf_id, references(:leafs, on_delete: :nothing, type: :binary_id)
      add :model_id, references(:scape_models, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:scapes, [:leaf_id])
    create index(:scapes, [:model_id])
  end
end
