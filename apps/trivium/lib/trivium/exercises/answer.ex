defmodule Trivium.Exercises.Answer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "answers" do
    field :answer_text, :string
    field :score, :integer

    belongs_to :question, Trivium.Exercises.Question
    belongs_to :user, Trivium.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:answer_text, :score, :question_id, :user_id])
    |> validate_required([:answer_text])
    |> assoc_constraint(:question)
    |> assoc_constraint(:user)
  end
end
