defmodule Trivium.Classrooms.Institution do
  use Ecto.Schema
  import Ecto.Changeset

  schema "institutions" do
    field :name, :string
    field :location, :string
    field :handle, :string
    field :slug, :string
    field :description, :string
    field :approved, :boolean, default: false

    belongs_to :user, Trivium.Accounts.User
    has_many :classrooms, Trivium.Classrooms.Classroom

    timestamps()
  end

  @doc false
  def changeset(institution, attrs) do
    institution
    |> cast(attrs, [:name, :description, :approved, :location, :handle, :user_id])
    |> validate_required([:name])
    |> assoc_constraint(:user)
    |> slugify_name()
  end

  defp slugify_name(changeset) do
    case fetch_change(changeset, :name) do
      {:ok, new_name} -> put_change(changeset, :slug, "#{slugify(new_name)}-#{Date.to_iso8601(DateTime.utc_now)}-#{Enum.random(10..199)}")
      :error -> changeset
    end
  end

  defp slugify(str) do
    str
    |> String.downcase()
    |> String.replace(~r/[^\w-]+/u, "-")
  end
end
