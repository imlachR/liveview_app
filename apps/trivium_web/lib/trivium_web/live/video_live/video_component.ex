defmodule TriviumWeb.VideoComponent do
  use TriviumWeb, :live_component

  alias Trivium.Multimedia
  alias Trivium.Multimedia.Video

  @impl true
  def mount(socket) do
    {:ok,
      allow_upload(socket, :video,
        accept: ~w(video/*),
        max_entries: 1, max_file_size: 2_000_000_000,
        external: &presign_entry/2)}
  end

  @impl true
  def update(%{content: content, videoform: videoform}, socket) do

    socket =
      socket
      |> assign(:content, content)
      |> assign(:concept_id, content.concept_id)
      |> assign(:videoform, videoform)
      |> assign(:changeset, Multimedia.change_video(%Video{}))
      |> assign(:loading, false)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("cancel-entry", %{"ref" => ref}, socket) do

    socket =
      socket
      |> push_patch(to: Routes.content_show_path(socket, :show, socket.assigns.concept_id, socket.assigns.content.id))

    {:noreply, cancel_upload(socket, :video, ref)}
  end

  defp ext(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    ext
  end

  @impl true
  def handle_event("upload", %{"video" => video_params}, socket) do
    video = put_video_url(socket, %Video{})

    case Multimedia.create_video(video, video_params, &consume_video(socket, &1)) do
      {:ok, video} ->

        socket =
          socket
          |> put_flash(:info, (gettext "Video successfully uploaded!"))
          |> assign(:loading, true)

          send(self(), {:video_uploaded})

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp put_video_url(socket, %Video{} = video) do
    {completed, []} = uploaded_entries(socket, :video)

    urls =
      for entry <- completed do
        Path.join(s3_host(), s3_key(entry))
      end

    url = Enum.at(urls, 0)

    %Video{video | url: url}
  end

  def consume_video(socket, %Video{} = video) do
    consume_uploaded_entries(socket, :video, fn _meta, _entry -> :ok end)

    {:ok, video}
  end

  @bucket "cf-simple-s3-origin-triviumlms-873738670572"
  defp s3_host, do: "//#{@bucket}.s3.amazonaws.com"
  defp s3_key(entry), do: "#{entry.uuid}.#{ext(entry)}"

  defp presign_entry(entry, socket) do
    uploads = socket.assigns.uploads
    key = s3_key(entry)

    config = %{
      scheme: "http://",
      host: "s3.amazonaws.com",
      region: "us-east-1",
      access_key_id: System.fetch_env!("AWS_ACCESS_KEY_ID"),
      secret_access_key: System.fetch_env!("AWS_SECRET_ACCESS_KEY")
    }

    {:ok, fields} =
      SimpleS3Upload.sign_form_upload(config, @bucket,
        key: key,
        content_type: entry.client_type,
        max_file_size: uploads.video.max_file_size,
        expires_in: :timer.hours(1)
      )

    meta = %{uploader: "S3", key: key, url: s3_host(), fields: fields}
    {:ok, meta, socket}
  end

end
