defmodule Trivium.Repo.Migrations.CreateYoutubes do
  use Ecto.Migration

  def change do
    create table(:youtubes) do
      add :url, :string, null: false
      add :legend, :string
      add :type, :string, default: "youtube"
      add :position, :integer, default: 1
      add :content_id, references(:contents, on_delete: :delete_all)

      timestamps()
    end

    create index(:youtubes, [:content_id])
  end
end
