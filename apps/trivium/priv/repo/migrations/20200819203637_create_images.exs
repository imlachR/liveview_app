defmodule Trivium.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :url, :string, null: false
      add :legend, :string
      add :type, :string, default: "image"
      add :position, :integer, default: 1
      add :content_id, references(:contents, on_delete: :delete_all)

      timestamps()
    end

    create index(:images, [:content_id])
  end
end
