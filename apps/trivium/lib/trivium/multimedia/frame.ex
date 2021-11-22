defmodule Trivium.Multimedia.Frame do
  use Ecto.Schema
  import Ecto.Changeset

  schema "frames" do
    field :code, :string
    field :legend, :string
    field :type, :string
    field :position, :integer

    belongs_to :content, Trivium.Classrooms.Content

    timestamps()
  end

  @doc false
  def changeset(frame, attrs) do
    frame
    |> cast(attrs, [:code, :content_id, :legend, :type, :position])
    |> validate_required([:code])
    |> assoc_constraint(:content)
  end
end
