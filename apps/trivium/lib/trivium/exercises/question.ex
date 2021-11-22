defmodule Trivium.Exercises.Question do
  use Ecto.Schema
  import Ecto.Changeset

  schema "questions" do
    field :question_text, :string
    field :type, :string
    field :theme, :string
    field :position, :integer
    field :score, :integer

    belongs_to :content, Trivium.Classrooms.Content

    has_many :answers, Trivium.Exercises.Answer
    has_many :quizzes, Trivium.Exercises.Quiz

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:question_text, :type, :theme, :position, :score, :content_id])
    |> validate_required([:question_text, :score])
    |> assoc_constraint(:content)
    |> cast_assoc(:quizzes)
  end
end
