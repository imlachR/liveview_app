defmodule Trivium.Multimedia.InternetImage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "internet_images" do
    field :url, :string
    field :legend, :string
    field :type, :string
    field :position, :integer 

    belongs_to :content, Trivium.Classrooms.Content

    timestamps()
  end

  @doc false
  def changeset(internet_image, attrs) do
    internet_image
    |> cast(attrs, [:url, :legend, :type, :position, :content_id])
    |> validate_required([:url])
    |> assoc_constraint(:content)
  end
end
