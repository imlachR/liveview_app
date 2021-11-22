defmodule Trivium.Repo.Migrations.CreateSubjects do
  use Ecto.Migration

  def change do
    create table(:subjects) do
      add :name, :string, null: false
      add :slug, :string
      add :color, :string
      add :position, :integer, default: 1
      add :published, :boolean, default: false
      add :classroom_id, references(:classrooms, on_delete: :delete_all)

      timestamps()
    end

    create index(:subjects, [:classroom_id])
    create unique_index(:subjects, [:slug])
  end
end
