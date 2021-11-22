defmodule Trivium.Exercises.Quiz do
  use Ecto.Schema
  import Ecto.Changeset

  schema "quizzes" do
    field :quiz_text, :string
    field :correct_quiz, :boolean, default: false

    field :temp_id, :string, virtual: true
    field :delete, :boolean, virtual: true

    belongs_to :question, Trivium.Classrooms.Content

    timestamps()
  end

  @doc false
  def changeset(quiz, attrs) do 
    quiz
    |> Map.put(:temp_id, (quiz.temp_id || attrs["temp_id"]))
    |> cast(attrs, [:quiz_text, :correct_quiz, :question_id, :delete])
    |> validate_required([:quiz_text, :correct_quiz])
    |> assoc_constraint(:question)
    |> maybe_mark_for_deletion()
  end

  def maybe_mark_for_deletion(%{data: %{id: nil}} = changeset), do: changeset
  def maybe_mark_for_deletion(changeset) do
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
