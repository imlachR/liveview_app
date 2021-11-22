defmodule Trivium.Classrooms.Subject do
  use Ecto.Schema
  import Ecto.Changeset

  schema "subjects" do
    field :name, :string
    field :slug, :string
    field :color, :string
    field :position, :integer

    belongs_to :classroom, Trivium.Classrooms.Classroom
    has_many :lessons, Trivium.Classrooms.Lesson

    timestamps()
  end

  @doc false
  def changeset(subject, attrs) do
    subject
    |> cast(attrs, [:name, :position, :color, :classroom_id])
    |> validate_required([:name])
    |> validate_length(:name, min: 2, max: 100)
    |> assoc_constraint(:classroom)
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
