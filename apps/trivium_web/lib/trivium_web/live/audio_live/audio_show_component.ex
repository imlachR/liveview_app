defmodule TriviumWeb.AudioShowComponent do
  use TriviumWeb, :live_component

  alias Trivium.Multimedia

  @impl true
  def update(%{media: media,
               edit_mode: edit_mode,
               contenteditable: contenteditable}, socket) do

    socket =
      socket
      |> assign(:media, media)
      |> assign(:edit_mode, edit_mode)
      |> assign(:contenteditable, contenteditable)

    {:ok, socket}
  end

  @impl true
  def handle_event("position-audio-up", %{"id" => id}, socket) do
    audio = Multimedia.get_audio!(id)
    new_position = audio.position + 1

    {:ok, _audio} =
      Multimedia.update_audio(
        audio,
        %{position: new_position}
      )

      send(self(), {:update_resource})
      {:noreply, socket}
  end

  @impl true
  def handle_event("position-audio-down", %{"id" => id}, socket) do
    audio = Multimedia.get_audio!(id)
    new_position = max(audio.position - 1, 1)

    {:ok, _audio} =
      Multimedia.update_audio(
        audio,
        %{position: new_position}
      )

      send(self(), {:update_resource})
      {:noreply, socket}
  end

  @bucket "cf-simple-s3-origin-triviumlms-873738670572"

  @impl true
  def handle_event("delete-audio", %{"id" => id, "url" => url}, socket) do
    parse_url = URI.parse(url)
    parsed_url = parse_url.path

    resp = ExAws.S3.delete_object(@bucket, parsed_url)
    |> ExAws.request!()

    audio = Multimedia.get_audio!(id)
    {:ok, _} = Multimedia.delete_audio(audio)

    send(self(), {:update_resource})
    {:noreply, socket}
  end

end
