defmodule Trivium.Multimedia.ImageUrl do
  use Ecto.Schema
  import Ecto.Changeset

  schema "image_urls" do
    field :image_url, :string
    field :legend, :string
    field :type, :string
    field :position, :integer

    timestamps()
  end

  @doc false
  def changeset(image_url, attrs) do
    image_url
    |> cast(attrs, [:image_url, :legend, :type, :position, :content_id])
    |> validate_required([:image_url])
    |> assoc_constraint(:content)
  end
end
