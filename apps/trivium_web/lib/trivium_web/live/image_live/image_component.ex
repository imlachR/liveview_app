defmodule TriviumWeb.ImageComponent do
  use TriviumWeb, :live_component

  alias Trivium.Multimedia
  alias Trivium.Multimedia.Image

  @impl true
  def mount(socket) do
    {:ok,
      allow_upload(socket, :image,
        accept: ~w(image/*),
        max_entries: 1,
        external: &presign_entry/2)}
  end

  @impl true
  def update(%{content: content, uploadform: uploadform}, socket) do

    socket =
      socket
      |> assign(:content, content)
      |> assign(:concept_id, content.concept_id)
      |> assign(:uploadform, uploadform)
      |> assign(:changeset, Multimedia.change_image(%Image{}))
      |> assign(:loading, false)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("cancel-entry", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :image, ref)}
  end

  defp ext(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    ext
  end

  @impl true
  def handle_event("upload", %{"image" => image_params}, socket) do
    image = put_image_url(socket, %Image{})

    case Multimedia.create_image(image, image_params, &consume_image(socket, &1)) do
      {:ok, image} ->

        socket =
          socket
          |> put_flash(:info, (gettext "Image successfully uploaded!"))
          |> assign(:loading, true)

          send(self(), {:image_uploaded})

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end


  defp put_image_url(socket, %Image{} = image) do
    {completed, []} = uploaded_entries(socket, :image)

    urls =
      for entry <- completed do
        Path.join(s3_host(), s3_key(entry))
      end

    url = Enum.at(urls, 0)

    %Image{image | url: url}
  end

  def consume_image(socket, %Image{} = image) do
    consume_uploaded_entries(socket, :image, fn _meta, _entry -> :ok end)

    {:ok, image}
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
        max_file_size: uploads.image.max_file_size,
        expires_in: :timer.hours(1)
      )

    meta = %{uploader: "S3", key: key, url: s3_host(), fields: fields}
    {:ok, meta, socket}
  end

end
