defmodule Trivium.Audio do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @versions [:original]
  @extension_whitelist ~w(.mp3 .ogg .wav)

  def acl(:original, _), do: :public_read

  def validate({file, _}) do
    file_extension = file.file_name |> Path.extname |> String.downcase
    Enum.member?(@extension_whitelist, file_extension)
  end

  def filename(version, {file, scope}) do
    file_name = Path.basename(file.file_name, Path.extname(file.file_name))
    "#{scope.uuid}_#{version}_#{file_name}"
  end

  def storage_dir(_, {file, scope}) do
    "uploads/audios/"
  end

end
