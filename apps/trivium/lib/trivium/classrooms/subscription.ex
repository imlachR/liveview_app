defmodule Trivium.Classrooms.Subscription do
  use Ecto.Schema
  import Ecto.Changeset

  schema "subscriptions" do
    field :accepted, :boolean, default: false
    field :paid, :boolean, default: false
    field :status, :string
    field :policy, :string, default: "student"

    belongs_to :user, Trivium.Accounts.User
    belongs_to :classroom, Trivium.Classrooms.Classroom

    timestamps()
  end

  @doc false
  def changeset(subscription, attrs) do
    subscription
    |> cast(attrs, [:user_id, :classroom_id, :status, :accepted, :policy])
    |> validate_required([:user_id, :classroom_id])
    |> unique_constraint(:user_id, name: :subscriptions_user_id_classroom_id_index, message: "You can't subscribe twice to the same classroom!")
    |> unique_constraint(:classroom_id, name: :subscriptions_user_id_classroom_id_index, message: "You can't subscribe twice to the same classroom!")
  end
end
