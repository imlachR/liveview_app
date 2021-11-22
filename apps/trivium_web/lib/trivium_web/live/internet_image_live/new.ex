defmodule TriviumWeb.InternetImageLive.New do
  use TriviumWeb, :live_view

  alias Trivium.Accounts
  alias Trivium.Multimedia
  alias Trivium.Multimedia.InternetImage

  @impl true
  def mount(params, session, socket) do
    concept_id = params["concept_id"]
    content_id = params["content_id"]

    if user = session["user_token"] && Accounts.get_user_by_session_token(session["user_token"]) do
      socket =
        socket
          |> assign(current_user: user)
          |> assign(changeset: Multimedia.change_internet_image(%InternetImage{}))
          |> assign(concept_id: concept_id)
          |> assign(content_id: content_id)

      {:ok, socket}
    else
      {:ok, assign(socket, current_user: nil)}
    end
  end

  @impl true
  def handle_event("validate", %{"internet_image" => internet_image_params}, socket) do
    changeset =
      %InternetImage{}
      |> Multimedia.change_internet_image(internet_image_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", %{"internet_image" => internet_image_params}, socket) do
    case Multimedia.create_internet_image(internet_image_params) do
      {:ok, internet_image} ->
        {:noreply,
          socket
            |> put_flash(:info, "Image created successfully!")
            |> push_redirect(to: Routes.concept_show_path(socket, :show, internet_image_params["concept_id"]))
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

end
