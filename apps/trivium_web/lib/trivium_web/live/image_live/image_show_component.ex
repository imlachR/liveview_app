defmodule TriviumWeb.ImageShowComponent do
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
  def handle_event("position-image-up", %{"id" => id}, socket) do
    image = Multimedia.get_image!(id)
    new_position = image.position + 1

    {:ok, _image} =
      Multimedia.update_image(
        image,
        %{position: new_position}
      )

      send(self(), {:update_resource})
      {:noreply, socket}
  end

  @impl true
  def handle_event("position-image-down", %{"id" => id}, socket) do
    image = Multimedia.get_image!(id)
    new_position = max(image.position - 1, 1)

    {:ok, _image} =
      Multimedia.update_image(
        image,
        %{position: new_position}
      )

      send(self(), {:update_resource})
      {:noreply, socket}
  end

  @bucket "cf-simple-s3-origin-triviumlms-873738670572"

  @impl true
  def handle_event("delete-image", %{"id" => id, "url" => url}, socket) do
    parse_url = URI.parse(url)
    parsed_url = parse_url.path

    image = Multimedia.get_image!(id)
    {:ok, _} = Multimedia.delete_image(image)

    send(self(), {:update_resource})

    resp = ExAws.S3.delete_object(@bucket, parsed_url)
    |> ExAws.request!()
    
    {:noreply, socket}
  end

end
