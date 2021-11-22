defmodule TriviumWeb.VideoShowComponent do
  use TriviumWeb, :live_component

  alias Trivium.Multimedia

  @impl true
  def update(%{media: media, edit_mode: edit_mode, contenteditable: contenteditable}, socket) do

    socket =
      socket
      |> assign(:media, media)
      |> assign(:edit_mode, edit_mode)
      |> assign(:contenteditable, contenteditable)

    {:ok, socket}
  end

  @impl true
  def handle_event("position-video-up", %{"id" => id}, socket) do
    video = Multimedia.get_video!(id)
    new_position = video.position + 1

    {:ok, _video} =
      Multimedia.update_video(
        video,
        %{position: new_position}
      )

      send(self(), {:update_resource})
      {:noreply, socket}
  end

  @impl true
  def handle_event("position-video-down", %{"id" => id}, socket) do
    video = Multimedia.get_video!(id)
    new_position = max(video.position - 1, 1)

    {:ok, _video} =
      Multimedia.update_video(
        video,
        %{position: new_position}
      )

      send(self(), {:update_resource})
      {:noreply, socket}
  end

  @bucket "cf-simple-s3-origin-triviumlms-873738670572"

  @impl true
  def handle_event("delete-video", %{"id" => id, "url" => url}, socket) do
    parse_url = URI.parse(url)
    parsed_url = parse_url.path

    resp = ExAws.S3.delete_object(@bucket, parsed_url)
    |> ExAws.request!()

    video = Multimedia.get_video!(id)
    {:ok, _} = Multimedia.delete_video(video)

    send(self(), {:update_resource})
    {:noreply, socket}
  end

end
