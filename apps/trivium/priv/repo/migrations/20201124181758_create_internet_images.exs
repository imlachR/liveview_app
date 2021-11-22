defmodule Trivium.Repo.Migrations.CreateInternetImages do
  use Ecto.Migration

  def change do 
    create table(:internet_images) do
      add :url, :string, null: false
      add :legend, :string
      add :type, :string, default: "internet-image"
      add :position, :integer, default: 1
      add :content_id, references(:contents, on_delete: :delete_all)

      timestamps()
    end

    create index(:internet_images, [:content_id])
  end
end
