defmodule Trivium.Multimedia do
  @moduledoc """
  The Multimedia context.
  """

  import Ecto.Query, warn: false
  alias Trivium.Repo

  alias Trivium.Multimedia.Image
  alias Trivium.Multimedia.Video
  alias Trivium.Multimedia.Audio
  alias Trivium.Multimedia.Writing
  alias Trivium.Multimedia.Youtube
  alias Trivium.Multimedia.Frame
  alias Trivium.Multimedia.ImageUrl

  @doc """
  Returns the list of images.

  ## Examples

      iex> list_images()
      [%Image{}, ...]

  """
  def list_images do
    Repo.all(Image)
  end

  @doc """
  Gets a single image.

  Raises `Ecto.NoResultsError` if the Image does not exist.

  ## Examples

      iex> get_image!(123)
      %Image{}

      iex> get_image!(456)
      ** (Ecto.NoResultsError)

  """
  def get_image!(id), do: Repo.get!(Image, id)

  @doc """
  Creates a image.

  ## Examples

      iex> create_image(%{field: value})
      {:ok, %Image{}}

      iex> create_image(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_image(image, attrs \\ %{}, after_save) do
    image
    |> Image.changeset(attrs)
    |> Repo.insert()
    |> after_save_image(after_save)
  end

  defp after_save_image({:ok, image}, func) do
    {:ok, _image} = func.(image)
  end
  defp after_save_image(error, _func), do: error

  @doc """
  Updates a image.

  ## Examples

      iex> update_image(image, %{field: new_value})
      {:ok, %Image{}}

      iex> update_image(image, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_image(%Image{} = image, attrs) do
    image
    |> Image.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a image.

  ## Examples

      iex> delete_image(image)
      {:ok, %Image{}}

      iex> delete_image(image)
      {:error, %Ecto.Changeset{}}

  """
  # def delete_image(%Image{} = image) do
  #   Repo.delete(image)
  # end

  def delete_image(%Image{} = image) do
    Repo.delete(image)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking image changes.

  ## Examples

      iex> change_image(image)
      %Ecto.Changeset{data: %Image{}}

  """
  def change_image(%Image{} = image, attrs \\ %{}) do
    Image.changeset(image, attrs)
  end



  @doc """
  Returns the list of videos.

  ## Examples

      iex> list_videos()
      [%Video{}, ...]

  """
  def list_videos do
    Repo.all(Video)
  end

  @doc """
  Gets a single video.

  Raises `Ecto.NoResultsError` if the Video does not exist.

  ## Examples

      iex> get_video!(123)
      %Video{}

      iex> get_video!(456)
      ** (Ecto.NoResultsError)

  """
  def get_video!(id), do: Repo.get!(Video, id)

  @doc """
  Creates a video.

  ## Examples

      iex> create_video(%{field: value})
      {:ok, %Video{}}

      iex> create_video(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_video(video, attrs \\ %{}, after_save) do
    video
    |> Video.changeset(attrs)
    |> Repo.insert()
    |> after_save_video(after_save)
  end

  defp after_save_video({:ok, video}, func) do
    {:ok, _video} = func.(video)
  end
  defp after_save_video(error, _func), do: error

  @doc """
  Updates a video.

  ## Examples

      iex> update_video(video, %{field: new_value})
      {:ok, %Video{}}

      iex> update_video(video, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_video(%Video{} = video, attrs) do
    video
    |> Video.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a video.

  ## Examples

      iex> delete_video(video)
      {:ok, %Video{}}

      iex> delete_video(video)
      {:error, %Ecto.Changeset{}}

  """

  def delete_video(%Video{} = video) do
    Repo.delete(video)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking video changes.

  ## Examples

      iex> change_video(video)
      %Ecto.Changeset{data: %Video{}}

  """
  def change_video(%Video{} = video, attrs \\ %{}) do
    Video.changeset(video, attrs)
  end



  @doc """
  Returns the list of audios.

  ## Examples

      iex> list_audios()
      [%Audio{}, ...]

  """
  def list_audios do
    Repo.all(Audio)
  end

  @doc """
  Gets a single audio.

  Raises `Ecto.NoResultsError` if the Audio does not exist.

  ## Examples

      iex> get_audio!(123)
      %Audio{}

      iex> get_audio!(456)
      ** (Ecto.NoResultsError)

  """
  def get_audio!(id), do: Repo.get!(Audio, id)

  @doc """
  Creates a audio.

  ## Examples

      iex> create_audio(%{field: value})
      {:ok, %Audio{}}

      iex> create_audio(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_audio(attrs \\ %{}) do
    %Audio{}
    |> Audio.changeset(attrs)
    |> Repo.insert()
  end

  def create_audio(audio, attrs \\ %{}, after_save) do
    audio
    |> Video.changeset(attrs)
    |> Repo.insert()
    |> after_save_audio(after_save)
  end

  defp after_save_audio({:ok, audio}, func) do
    {:ok, _audio} = func.(audio)
  end
  defp after_save_audio(error, _func), do: error

  @doc """
  Updates a audio.

  ## Examples

      iex> update_audio(audio, %{field: new_value})
      {:ok, %Audio{}}

      iex> update_audio(audio, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_audio(%Audio{} = audio, attrs) do
    audio
    |> Audio.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a audio.

  ## Examples

      iex> delete_audio(audio)
      {:ok, %Audio{}}

      iex> delete_audio(audio)
      {:error, %Ecto.Changeset{}}

  """

  def delete_audio(%Audio{} = audio) do
    Repo.delete(audio)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking audio changes.

  ## Examples

      iex> change_audio(audio)
      %Ecto.Changeset{data: %Audio{}}

  """
  def change_audio(%Audio{} = audio, attrs \\ %{}) do
    Audio.changeset(audio, attrs)
  end



  @doc """
  Returns the list of writings.

  ## Examples

      iex> list_writings()
      [%Writing{}, ...]

  """
  def list_writings do
    Repo.all(Writing)
  end

  @doc """
  Gets a single writing.

  Raises `Ecto.NoResultsError` if the Writing does not exist.

  ## Examples

      iex> get_writing!(123)
      %Writing{}

      iex> get_writing!(456)
      ** (Ecto.NoResultsError)

  """

  def get_writing!(id) do
    Writing
    |> Repo.get!(id)
    |> Repo.preload(:content)
    |> Repo.preload(content: :concept)
  end

  @doc """
  Creates a writing.

  ## Examples

      iex> create_writing(%{field: value})
      {:ok, %Writing{}}

      iex> create_writing(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_writing(attrs \\ %{}) do
    %Writing{}
    |> Writing.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a writing.

  ## Examples

      iex> update_writing(writing, %{field: new_value})
      {:ok, %Writing{}}

      iex> update_writing(writing, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_writing(%Writing{} = writing, attrs) do
    writing
    |> Writing.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a writing.

  ## Examples

      iex> delete_writing(writing)
      {:ok, %Writing{}}

      iex> delete_writing(writing)
      {:error, %Ecto.Changeset{}}

  """
  def delete_writing(%Writing{} = writing) do
    Repo.delete(writing)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking writing changes.

  ## Examples

      iex> change_writing(writing)
      %Ecto.Changeset{data: %Writing{}}

  """
  def change_writing(%Writing{} = writing, attrs \\ %{}) do
    Writing.changeset(writing, attrs)
  end



  @doc """
  Returns the list of youtubes.

  ## Examples

      iex> list_youtubes()
      [%Youtube{}, ...]

  """
  def list_youtubes do
    Repo.all(Youtube)
  end

  @doc """
  Gets a single youtube.

  Raises `Ecto.NoResultsError` if the Youtube does not exist.

  ## Examples

      iex> get_youtube!(123)
      %Youtube{}

      iex> get_youtube!(456)
      ** (Ecto.NoResultsError)

  """
  def get_youtube!(id), do: Repo.get!(Youtube, id) |> Repo.preload(:content)

  @doc """
  Creates a youtube.

  ## Examples

      iex> create_youtube(%{field: value})
      {:ok, %Youtube{}}

      iex> create_youtube(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_youtube(attrs \\ %{}) do
    %Youtube{}
    |> Youtube.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a youtube.

  ## Examples

      iex> update_youtube(youtube, %{field: new_value})
      {:ok, %Youtube{}}

      iex> update_youtube(youtube, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_youtube(%Youtube{} = youtube, attrs) do
    youtube
    |> Youtube.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a youtube.

  ## Examples

      iex> delete_youtube(youtube)
      {:ok, %Youtube{}}

      iex> delete_youtube(youtube)
      {:error, %Ecto.Changeset{}}

  """
  def delete_youtube(%Youtube{} = youtube) do
    Repo.delete(youtube)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking youtube changes.

  ## Examples

      iex> change_youtube(youtube)
      %Ecto.Changeset{data: %Youtube{}}

  """
  def change_youtube(%Youtube{} = youtube, attrs \\ %{}) do
    Youtube.changeset(youtube, attrs)
  end



  @doc """
  Returns the list of frames.

  ## Examples

      iex> list_frames()
      [%Frame{}, ...]

  """
  def list_frames do
    Repo.all(Frame)
  end

  @doc """
  Gets a single frame.

  Raises `Ecto.NoResultsError` if the Frame does not exist.

  ## Examples

      iex> get_frame!(123)
      %Frame{}

      iex> get_frame!(456)
      ** (Ecto.NoResultsError)

  """
  def get_frame!(id), do: Repo.get!(Frame, id) |> Repo.preload(:content)

  @doc """
  Creates a frame.

  ## Examples

      iex> create_frame(%{field: value})
      {:ok, %Frame{}}

      iex> create_frame(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_frame(attrs \\ %{}) do
    %Frame{}
    |> Frame.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a frame.

  ## Examples

      iex> update_frame(frame, %{field: new_value})
      {:ok, %Frame{}}

      iex> update_frame(frame, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_frame(%Frame{} = frame, attrs) do
    frame
    |> Frame.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a frame.

  ## Examples

      iex> delete_frame(frame)
      {:ok, %Frame{}}

      iex> delete_frame(frame)
      {:error, %Ecto.Changeset{}}

  """
  def delete_frame(%Frame{} = frame) do
    Repo.delete(frame)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking frame changes.

  ## Examples

      iex> change_frame(frame)
      %Ecto.Changeset{data: %Frame{}}

  """
  def change_frame(%Frame{} = frame, attrs \\ %{}) do
    Frame.changeset(frame, attrs)
  end


  @doc """
  Returns the list of image_urls.

  ## Examples

      iex> list_image_urls()
      [%ImageUrl{}, ...]

  """
  def list_image_urls do
    Repo.all(ImageUrl)
  end

  @doc """
  Gets a single image_url.

  Raises `Ecto.NoResultsError` if the Image url does not exist.

  ## Examples

      iex> get_image_url!(123)
      %ImageUrl{}

      iex> get_image_url!(456)
      ** (Ecto.NoResultsError)

  """
  def get_image_url!(id), do: Repo.get!(ImageUrl, id)

  @doc """
  Creates a image_url.

  ## Examples

      iex> create_image_url(%{field: value})
      {:ok, %ImageUrl{}}

      iex> create_image_url(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_image_url(attrs \\ %{}) do
    %ImageUrl{}
    |> ImageUrl.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a image_url.

  ## Examples

      iex> update_image_url(image_url, %{field: new_value})
      {:ok, %ImageUrl{}}

      iex> update_image_url(image_url, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_image_url(%ImageUrl{} = image_url, attrs) do
    image_url
    |> ImageUrl.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a image_url.

  ## Examples

      iex> delete_image_url(image_url)
      {:ok, %ImageUrl{}}

      iex> delete_image_url(image_url)
      {:error, %Ecto.Changeset{}}

  """
  def delete_image_url(%ImageUrl{} = image_url) do
    Repo.delete(image_url)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking image_url changes.

  ## Examples

      iex> change_image_url(image_url)
      %Ecto.Changeset{data: %ImageUrl{}}

  """
  def change_image_url(%ImageUrl{} = image_url, attrs \\ %{}) do
    ImageUrl.changeset(image_url, attrs)
  end

  alias Trivium.Multimedia.InternetImage

  @doc """
  Returns the list of internet_images.

  ## Examples

      iex> list_internet_images()
      [%InternetImage{}, ...]

  """
  def list_internet_images do
    Repo.all(InternetImage)
  end

  @doc """
  Gets a single internet_image.

  Raises `Ecto.NoResultsError` if the Internet image does not exist.

  ## Examples

      iex> get_internet_image!(123)
      %InternetImage{}

      iex> get_internet_image!(456)
      ** (Ecto.NoResultsError)

  """
  def get_internet_image!(id), do: Repo.get!(InternetImage, id)

  @doc """
  Creates a internet_image.

  ## Examples

      iex> create_internet_image(%{field: value})
      {:ok, %InternetImage{}}

      iex> create_internet_image(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_internet_image(attrs \\ %{}) do
    %InternetImage{}
    |> InternetImage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a internet_image.

  ## Examples

      iex> update_internet_image(internet_image, %{field: new_value})
      {:ok, %InternetImage{}}

      iex> update_internet_image(internet_image, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_internet_image(%InternetImage{} = internet_image, attrs) do
    internet_image
    |> InternetImage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a internet_image.

  ## Examples

      iex> delete_internet_image(internet_image)
      {:ok, %InternetImage{}}

      iex> delete_internet_image(internet_image)
      {:error, %Ecto.Changeset{}}

  """
  def delete_internet_image(%InternetImage{} = internet_image) do
    Repo.delete(internet_image)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking internet_image changes.

  ## Examples

      iex> change_internet_image(internet_image)
      %Ecto.Changeset{data: %InternetImage{}}

  """
  def change_internet_image(%InternetImage{} = internet_image, attrs \\ %{}) do
    InternetImage.changeset(internet_image, attrs)
  end
end
