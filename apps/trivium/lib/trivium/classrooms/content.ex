defmodule Trivium.Classrooms.Content do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contents" do
    field :name, :string
    field :slug, :string
    field :theme, :string
    field :position, :integer

    belongs_to :concept, Trivium.Classrooms.Concept

    has_many :images, Trivium.Multimedia.Image
    has_many :internet_images, Trivium.Multimedia.InternetImage
    has_many :videos, Trivium.Multimedia.Video
    has_many :audios, Trivium.Multimedia.Audio
    has_many :youtubes, Trivium.Multimedia.Youtube
    has_many :writings, Trivium.Multimedia.Writing
    has_many :frames, Trivium.Multimedia.Frame

    has_many :questions, Trivium.Exercises.Question

    timestamps()
  end

  @doc false
  def changeset(content, attrs) do
    content
    |> cast(attrs, [:name, :position, :concept_id])
    |> assoc_constraint(:concept)
  end
end
