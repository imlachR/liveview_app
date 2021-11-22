defmodule TriviumWeb.InternetImageShowComponent do
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

  # @impl true
  # def handle_event("update-internet-image-legend", %{"legend" => legend, "id" => id}, socket) do
  #   id = String.to_integer(id)
  #   internet_image = Multimedia.get_internet_image!(id)
  #
  #   case Multimedia.update_internet_image(internet_image, %{legend: legend}) do
  #     {:ok, _internet_image} ->
  #       {:noreply, assign(socket, :content, Classrooms.get_content!(socket.assigns.content.id))}
  #
  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       {:noreply, assign(socket, :changeset, changeset)}
  #   end
  # end

  @impl true
  def handle_event("position-internet-image-up", %{"id" => id}, socket) do
    internet_image = Multimedia.get_internet_image!(id)
    new_position = internet_image.position + 1

    {:ok, _internet_image} =
      Multimedia.update_internet_image(
        internet_image,
        %{position: new_position}
      )

      send(self(), {:update_resource})
      {:noreply, socket}
  end

  @impl true
  def handle_event("position-internet-image-down", %{"id" => id}, socket) do
    internet_image = Multimedia.get_internet_image!(id)
    new_position = max(internet_image.position - 1, 1)

    {:ok, _internet_image} =
      Multimedia.update_internet_image(
        internet_image,
        %{position: new_position}
      )

      send(self(), {:update_resource})
      {:noreply, socket}
  end

  @impl true
  def handle_event("delete-internet-image", %{"id" => id}, socket) do
    internet_image = Multimedia.get_internet_image!(id)
    {:ok, _} = Multimedia.delete_internet_image(internet_image)

    send(self(), {:update_resource})
    {:noreply, socket}
  end

end
