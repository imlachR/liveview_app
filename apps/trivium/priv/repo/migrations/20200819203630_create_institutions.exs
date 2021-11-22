defmodule Trivium.Repo.Migrations.CreateInstitutions do
  use Ecto.Migration

  def change do
    create table(:institutions) do
      add :name, :string, null: false
      add :slug, :string
      add :location, :string
      add :handle, :string
      add :description, :text
      add :approved, :boolean, default: false
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:institutions, [:user_id])
    create unique_index(:institutions, [:slug, :handle])
  end
end
