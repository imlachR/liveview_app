defmodule TriviumWeb.AvatarComponent do
  use TriviumWeb, :live_component

  alias Trivium.Accounts
  alias Trivium.Accounts.Avatar

  @impl true
  def mount(socket) do
    {:ok,
      allow_upload(socket, :photo,
        accept: ~w(.png .jpg .jpeg .webp),
        max_entries: 1,
        external: &presign_entry/2)}
  end

  @impl true
  def update(%{user: user, user_score: user_score}, socket) do
    socket =
      socket
      |> assign(:user, Accounts.get_user!(user.id))
      |> assign(:user_score, user_score)
      |> assign(:changeset, Accounts.change_avatar(%Avatar{}))

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("cancel-entry", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :photo, ref)}
  end

  @impl true
  def handle_event("delete-avatar", %{"id" => id, "user" => user}, socket) do
    avatar = Accounts.get_avatar!(id)
    {:ok, _} = Accounts.delete_avatar(avatar)

    {:noreply, assign(socket, user: Accounts.get_user!(user))}
  end

  defp ext(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    ext
  end

  @impl true
  def handle_event("upload", %{"avatar" => avatar_params}, socket) do
    avatar = put_avatar_url(socket, %Avatar{})

    case Accounts.create_avatar(avatar, avatar_params, &consume_avatar(socket, &1)) do
      {:ok, avatar} ->
        {:noreply,
          socket
          |> put_flash(:info, "Avatar successfully uploaded!")
          |> push_redirect(to: Routes.profile_show_path(socket, :show, socket.assigns.user.id))
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp put_avatar_url(socket, %Avatar{} = avatar) do
    {completed, []} = uploaded_entries(socket, :photo)

    urls =
      for entry <- completed do
        Path.join(s3_host(), s3_key(entry))
      end

    url = Enum.at(urls, 0)

    %Avatar{avatar | url: url}
  end

  def consume_avatar(socket, %Avatar{} = avatar) do
    consume_uploaded_entries(socket, :photo, fn _meta, _entry -> :ok end)

    {:ok, avatar}
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
        max_file_size: uploads.photo.max_file_size,
        expires_in: :timer.hours(1)
      )

    meta = %{uploader: "S3", key: key, url: s3_host(), fields: fields}
    {:ok, meta, socket}
  end

end
