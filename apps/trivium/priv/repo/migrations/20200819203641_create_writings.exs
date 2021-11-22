defmodule Trivium.Repo.Migrations.CreateWritings do
  use Ecto.Migration

  def change do
    create table(:writings) do
      add :body, :text, null: false
      add :type, :string, default: "writing"
      add :position, :integer, default: 1
      add :content_id, references(:contents, on_delete: :delete_all)

      timestamps()
    end

    create index(:writings, [:content_id])
  end
end
