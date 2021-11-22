defmodule Trivium.Repo.Migrations.CreateFrames do
  use Ecto.Migration

  def change do
    create table(:frames) do
      add :code, :text, null: false
      add :legend, :string
      add :type, :string, default: "frame"
      add :position, :integer, default: 1
      add :content_id, references(:contents, on_delete: :delete_all)

      timestamps()
    end

    create index(:frames, [:content_id])
  end
end
