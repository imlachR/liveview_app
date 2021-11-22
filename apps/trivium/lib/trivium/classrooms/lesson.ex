defmodule Trivium.Classrooms.Lesson do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lessons" do
    field :position, :integer
    field :name, :string
    field :slug, :string

    belongs_to :subject, Trivium.Classrooms.Subject
    has_many :concepts, Trivium.Classrooms.Concept

    timestamps()
  end

  @doc false
  def changeset(lesson, attrs) do
    lesson
    |> cast(attrs, [:name, :position, :subject_id])
    |> validate_required([:name])
    |> assoc_constraint(:subject)
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
