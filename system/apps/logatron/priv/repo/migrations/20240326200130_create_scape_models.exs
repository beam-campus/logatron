defmodule Logatron.Repo.Migrations.CreateScapeModels do
  use Ecto.Migration

  def change do
    create table(:scape_models, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :text
      add :definition, :text

      timestamps()
    end
  end
end
