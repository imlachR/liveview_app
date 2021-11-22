defmodule Trivium.Multimedia.Audio do
  use Ecto.Schema
  import Ecto.Changeset

  schema "audios" do
    field :url, :string
    field :legend, :string
    field :type, :string
    field :position, :integer

    belongs_to :content, Trivium.Classrooms.Content

    timestamps()
  end

  @doc false
  def changeset(audio, attrs) do
    audio
    |> cast(attrs, [:url, :legend, :type, :position, :content_id])
    |> validate_required([:url])
    |> assoc_constraint(:content)
  end
end
