defmodule Trivium.Repo.Migrations.CreateLessons do
  use Ecto.Migration

  def change do
    create table(:lessons) do
      add :name, :string, null: false
      add :slug, :string
      add :position, :integer, default: 1
      add :published, :boolean, default: false
      add :subject_id, references(:subjects, on_delete: :delete_all)

      timestamps()
    end

    create index(:lessons, [:subject_id])
    create unique_index(:lessons, [:slug])
  end
end
