defmodule Trivium.Repo.Migrations.CreateConcepts do
  use Ecto.Migration

  def change do
    create table(:concepts) do
      add :name, :string, null: false
      add :active_call, :boolean, default: false
      add :slug, :string
      add :position, :integer, default: 1
      add :published, :boolean, default: false
      add :review_date, :date
      add :lesson_id, references(:lessons, on_delete: :delete_all)

      timestamps()
    end

    create index(:concepts, [:lesson_id])
    create unique_index(:concepts, [:slug])
  end
end
