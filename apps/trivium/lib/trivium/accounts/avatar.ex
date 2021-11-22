defmodule Trivium.Accounts.Avatar do
  use Ecto.Schema
  import Ecto.Changeset

  schema "avatars" do
    field :url, :string
    belongs_to :user, Trivium.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(avatar, attrs) do
    avatar
    |> cast(attrs, [:url, :user_id])
    |> validate_required([:url])
    |> assoc_constraint(:user)
  end
end
