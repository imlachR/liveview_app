defmodule Trivium.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :question_text, :text
      add :image_url, :string
      add :video_url, :string
      add :audio_url, :string
      add :code, :text
      add :response_correct_answer, :text
      add :response_wrong_answer, :text
      add :type, :string, default: "question"
      add :theme, :string, default: "dark-theme"
      add :position, :integer, default: 1
      add :locked, :boolean, default: false
      add :score, :integer
      add :content_id, references(:contents, on_delete: :delete_all)

      timestamps()
    end

    create index(:questions, [:content_id])
  end
end
