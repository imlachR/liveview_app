defmodule Trivium.Classrooms.Classroom do
  use Ecto.Schema
  import Ecto.Changeset

  schema "classrooms" do
    field :description, :string
    field :name, :string
    field :prefix, :string
    field :handle, :string
    field :slug, :string
    field :position, :integer

    belongs_to :institution, Trivium.Classrooms.Institution
    has_many :subjects, Trivium.Classrooms.Subject

    has_many :subscriptions, Trivium.Classrooms.Subscription
    many_to_many :users, Trivium.Accounts.User, join_through: "subscriptions"

    timestamps()
  end

  @doc false
  def changeset(classroom, attrs) do
    classroom
    |> cast(attrs, [:name, :prefix, :handle, :description, :position, :institution_id])
    |> validate_required([:name])
    |> assoc_constraint(:institution)
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
