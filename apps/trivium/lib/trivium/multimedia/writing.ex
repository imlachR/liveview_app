defmodule Trivium.Multimedia.Writing do
  use Ecto.Schema
  import Ecto.Changeset

  schema "writings" do
    field :body, :string
    field :type, :string
    field :position, :integer

    belongs_to :content, Trivium.Classrooms.Content

    timestamps()
  end

  @doc false
  def changeset(writing, attrs) do
    writing
    |> cast(attrs, [:body, :content_id, :type, :position])
    |> validate_required([:body])
    |> assoc_constraint(:content)
  end
end
