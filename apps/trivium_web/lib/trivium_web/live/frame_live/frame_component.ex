defmodule TriviumWeb.FrameComponent do
  use TriviumWeb, :live_component

  alias Trivium.Multimedia
  alias Trivium.Multimedia.Frame

  @impl true
  def update(%{content: content, frameform: frameform}, socket) do

    socket =
      socket
      |> assign(:content, content)
      |> assign(:frameform, frameform)
      |> assign(:changeset, Multimedia.change_frame(%Frame{}))

    {:ok, socket}
  end

  @impl true
  def handle_event("cancel-frameform", _, socket) do
    send(self(), {:close_frameform})
    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", %{"frame" => frame_params}, socket) do
    changeset =
      %Frame{}
      |> Multimedia.change_frame(frame_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

end
