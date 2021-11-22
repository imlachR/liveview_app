defmodule TriviumWeb.WritingShowComponent do
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
  def handle_event("position-writing-up", %{"id" => id}, socket) do
    writing = Multimedia.get_writing!(id)
    new_position = writing.position + 1

    {:ok, _writing} =
      Multimedia.update_writing(
        writing,
        %{position: new_position}
      )

      send(self(), {:update_resource})
      {:noreply, socket}
  end

  @impl true
  def handle_event("position-writing-down", %{"id" => id}, socket) do
    writing = Multimedia.get_writing!(id)
    new_position = max(writing.position - 1, 1)

    {:ok, _writing} =
      Multimedia.update_writing(
        writing,
        %{position: new_position}
      )

      send(self(), {:update_resource})
      {:noreply, socket}
  end

  @impl true
  def handle_event("delete-writing", %{"id" => id}, socket) do
    writing = Multimedia.get_writing!(id)
    {:ok, _} = Multimedia.delete_writing(writing)

    send(self(), {:update_resource})
    {:noreply, socket}
  end

  defp as_html(txt) do
    txt
    |> HtmlSanitizeEx.html5()
    |> raw
  end

end
