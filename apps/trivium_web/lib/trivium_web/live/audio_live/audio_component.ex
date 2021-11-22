defmodule TriviumWeb.AudioComponent do
  use TriviumWeb, :live_component

  alias Trivium.Multimedia
  alias Trivium.Multimedia.Audio

  @impl true
  def mount(socket) do
    {:ok,
      allow_upload(socket, :audio,
        accept: ~w(audio/*),
        max_entries: 1, max_file_size: 2_000_000_000,
        external: &presign_entry/2)}
  end

  @impl true
  def update(%{content: content, audioform: audioform}, socket) do

    socket =
      socket
      |> assign(:content, content)
      |> assign(:concept_id, content.concept_id)
      |> assign(:audioform, audioform)
      |> assign(:changeset, Multimedia.change_audio(%Audio{}))
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
  def handle_event("upload", %{"audio" => audio_params}, socket) do
    audio = put_audio_url(socket, %Audio{})

    case Multimedia.create_audio(audio, audio_params, &consume_audio(socket, &1)) do
      {:ok, audio} ->

        socket =
          socket
          |> put_flash(:info, (gettext "Audio successfully uploaded!"))
          |> assign(:loading, true)

          send(self(), {:audio_uploaded})

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp put_audio_url(socket, %Audio{} = audio) do
    {completed, []} = uploaded_entries(socket, :audio)

    urls =
      for entry <- completed do
        Path.join(s3_host(), s3_key(entry))
      end

    url = Enum.at(urls, 0)

    %Audio{audio | url: url}
  end

  def consume_audio(socket, %Audio{} = audio) do
    consume_uploaded_entries(socket, :audio, fn _meta, _entry -> :ok end)

    {:ok, audio}
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
        max_file_size: uploads.audio.max_file_size,
        expires_in: :timer.hours(1)
      )

    meta = %{uploader: "S3", key: key, url: s3_host(), fields: fields}
    {:ok, meta, socket}
  end

end
