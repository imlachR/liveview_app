defmodule Trivium.Repo.Migrations.CreateAudios do
  use Ecto.Migration

  def change do
    create table(:audios) do
      add :url, :string, null: false
      add :legend, :string
      add :type, :string, default: "audio"
      add :position, :integer, default: 1
      add :content_id, references(:contents, on_delete: :delete_all)

      timestamps()
    end

    create index(:audios, [:content_id])
  end
end
