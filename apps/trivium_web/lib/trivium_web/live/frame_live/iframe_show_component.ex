defmodule TriviumWeb.IframeShowComponent do
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
  def handle_event("position-frame-up", %{"id" => id}, socket) do
    frame = Multimedia.get_frame!(id)
    new_position = frame.position + 1

    {:ok, _frame} =
      Multimedia.update_frame(
        frame,
        %{position: new_position}
      )

      send(self(), {:update_resource})
      {:noreply, socket}
  end

  @impl true
  def handle_event("position-frame-down", %{"id" => id}, socket) do
    frame = Multimedia.get_frame!(id)
    new_position = max(frame.position - 1, 1)

    {:ok, _frame} =
      Multimedia.update_frame(
        frame,
        %{position: new_position}
      )

      send(self(), {:update_resource})
      {:noreply, socket}
  end

  @impl true
  def handle_event("delete-frame", %{"id" => id}, socket) do
    frame = Multimedia.get_frame!(id)
    {:ok, _} = Multimedia.delete_frame(frame)

    send(self(), {:update_resource})
    {:noreply, socket}
  end

  defp as_html(txt) do
    txt
    |> HtmlSanitizeEx.html5()
    |> raw
  end

end
