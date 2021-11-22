defmodule Trivium.Classrooms.Concept do
  use Ecto.Schema
  import Ecto.Changeset

  schema "concepts" do
    field :name, :string
    field :slug, :string
    field :position, :integer

    belongs_to :lesson, Trivium.Classrooms.Lesson
    has_many :contents, Trivium.Classrooms.Content

    has_many :progresses, Trivium.Classrooms.Progress
    many_to_many :users, Trivium.Accounts.User, join_through: "progresses"

    timestamps()
  end

  @doc false
  def changeset(concept, attrs) do
    concept
    |> cast(attrs, [:name, :position, :lesson_id])
    |> validate_required([:name])
    |> assoc_constraint(:lesson)
    |> cast_assoc(:contents)
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
