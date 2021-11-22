defmodule Trivium.Repo.Migrations.CreateAnswers do
  use Ecto.Migration

  def change do
    create table(:answers) do
      add :answer_text, :text
      add :image_url, :string
      add :video_url, :string
      add :audio_url, :string
      add :score, :integer
      add :question_id, references(:questions, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:answers, [:question_id])
    create index(:answers, [:user_id])
  end
end
