defmodule Trivium.Image do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @versions [:original, :square]
  @extension_whitelist ~w(.jpg .jpeg .gif .png .webp)

  def acl(:square, _), do: :public_read

  def validate({file, _}) do
    file_extension = file.file_name |> Path.extname |> String.downcase
    Enum.member?(@extension_whitelist, file_extension)
  end

  def transform(:square, _) do
    {:convert, "-resize 1280x1280^ -gravity center -extent 1280x1280"}
  end

  def filename(version, {file, scope}) do
    file_name = Path.basename(file.file_name, Path.extname(file.file_name))
    "#{scope.uuid}_#{version}_#{file_name}"
  end

  def storage_dir(_, {file, scope}) do
    "uploads/images/"
  end

end
