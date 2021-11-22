defmodule Trivium.Multimedia.Youtube do
  use Ecto.Schema
  import Ecto.Changeset

  schema "youtubes" do
    field :url, :string
    field :legend, :string
    field :type, :string
    field :position, :integer

    belongs_to :content, Trivium.Classrooms.Content

    timestamps()
  end

  @doc false
  def changeset(youtube, attrs) do
    youtube
    |> cast(attrs, [:url, :legend, :type, :position, :content_id])
    |> validate_required([:url])
    |> assoc_constraint(:content)
  end
end
