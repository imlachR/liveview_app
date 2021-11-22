defmodule Trivium.Repo.Migrations.CreateSubscriptions do
  use Ecto.Migration

  def change do
    create table(:subscriptions) do
      add :accepted, :boolean, default: false, null: false
      add :paid, :boolean, default: false, null: false
      add :status, :string
      add :policy, :string, default: "student"
      add :user_id, references(:users, on_delete: :delete_all)
      add :classroom_id, references(:classrooms, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:subscriptions, [:user_id, :classroom_id])
  end
end
