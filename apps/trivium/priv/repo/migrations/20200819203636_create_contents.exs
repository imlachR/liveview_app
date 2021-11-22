defmodule Trivium.Repo.Migrations.CreateContents do
  use Ecto.Migration

  def change do
    create table(:contents) do
      add :name, :string
      add :theme, :string
      add :slug, :string
      add :position, :integer, default: 1
      add :published, :boolean, default: false
      add :concept_id, references(:concepts, on_delete: :delete_all)

      timestamps()
    end

    create index(:contents, [:concept_id])
    create unique_index(:contents, [:slug])
  end
end
