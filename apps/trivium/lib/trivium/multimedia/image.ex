defmodule Trivium.Multimedia.Image do
  use Ecto.Schema
  import Ecto.Changeset

  schema "images" do
    field :url, :string
    field :legend, :string
    field :type, :string
    field :position, :integer

    belongs_to :content, Trivium.Classrooms.Content

    timestamps()
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:url, :legend, :type, :position, :content_id])
    |> validate_required([:url])
    |> assoc_constraint(:content)
  end
end
