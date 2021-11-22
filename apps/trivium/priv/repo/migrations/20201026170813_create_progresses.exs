defmodule Trivium.Repo.Migrations.CreateProgresses do
  use Ecto.Migration

  def change do
    create table(:progresses) do
      add :status, :string, default: "not-completed", null: false
      add :classroom_id, :integer
      add :concept_id, references(:concepts, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:progresses, [:concept_id])
    create index(:progresses, [:user_id])
    create unique_index(:progresses, [:user_id, :concept_id])
  end
end
