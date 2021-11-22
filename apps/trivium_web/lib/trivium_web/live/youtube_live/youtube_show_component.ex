defmodule TriviumWeb.YoutubeShowComponent do
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
  def handle_event("position-youtube-up", %{"id" => id}, socket) do
    youtube = Multimedia.get_youtube!(id)
    new_position = youtube.position + 1

    {:ok, _youtube} =
      Multimedia.update_youtube(
        youtube,
        %{position: new_position}
      )

      send(self(), {:update_resource})
      {:noreply, socket}
  end

  @impl true
  def handle_event("position-youtube-down", %{"id" => id}, socket) do
    youtube = Multimedia.get_youtube!(id)
    new_position = max(youtube.position - 1, 1)

    {:ok, _youtube} =
      Multimedia.update_youtube(
        youtube,
        %{position: new_position}
      )

      send(self(), {:update_resource})
      {:noreply, socket}
  end

  @impl true
  def handle_event("delete-youtube", %{"id" => id}, socket) do
    youtube = Multimedia.get_youtube!(id)
    {:ok, _} = Multimedia.delete_youtube(youtube)

    send(self(), {:update_resource})
    {:noreply, socket}
  end

  defp player_id(video) do
    Regex.named_captures(~r{^.*(?:youtu\.be/|\w+/|v=)(?<id>[^#&?]*)}, video)
    |> get_in(["id"])
  end

end
