defmodule Trivium.Repo.Migrations.CreateClassrooms do
  use Ecto.Migration

  def change do
    create table(:classrooms) do
      add :name, :string, null: false
      add :prefix, :string
      add :slug, :string
      add :handle, :string
      add :description, :text
      add :position, :integer, default: 1
      add :published, :boolean, default: false
      add :institution_id, references(:institutions, on_delete: :delete_all)

      timestamps()
    end

    create index(:classrooms, [:institution_id])
    create unique_index(:classrooms, [:slug, :handle])
  end
end
