defmodule Trivium.Repo.Migrations.CreateQuizzes do
  use Ecto.Migration

  def change do
    create table(:quizzes) do
      add :quiz_text, :text
      add :image_url, :string
      add :video_url, :string
      add :audio_url, :string
      add :correct_quiz, :boolean, default: false
      add :question_id, references(:questions, on_delete: :delete_all)

      timestamps()
    end

    create index(:quizzes, [:question_id])
  end
end
