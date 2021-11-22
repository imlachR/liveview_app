defmodule Trivium.Classrooms.Progress do
  use Ecto.Schema
  import Ecto.Changeset

  schema "progresses" do
    field :status, :string
    field :classroom_id, :integer

    belongs_to :concept, Trivium.Classrooms.Concept
    belongs_to :user, Trivium.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(progress, attrs) do
    progress
    |> cast(attrs, [:status, :classroom_id, :concept_id, :user_id])
    |> validate_required([:status, :user_id, :concept_id])
    |> assoc_constraint(:concept)
    |> assoc_constraint(:user)
    |> unique_constraint(:user_id, name: :progresses_user_id_concept_id_index, message: "You can't save twice to the same user!")
    |> unique_constraint(:concept_id, name: :progresses_user_id_concept_id_index, message: "You can't save twice to the same concept!")
  end
end
