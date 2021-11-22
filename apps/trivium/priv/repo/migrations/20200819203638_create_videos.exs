defmodule Trivium.Repo.Migrations.CreateVideos do
  use Ecto.Migration

  def change do
    create table(:videos) do
      add :url, :string, null: false
      add :legend, :string
      add :type, :string, default: "video"
      add :position, :integer, default: 1
      add :content_id, references(:contents, on_delete: :delete_all)

      timestamps()
    end

    create index(:videos, [:content_id])
  end
end
