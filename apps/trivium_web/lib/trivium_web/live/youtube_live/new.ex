defmodule TriviumWeb.YoutubeLive.New do
  use TriviumWeb, :live_view

  alias Trivium.Accounts
  alias Trivium.Multimedia
  alias Trivium.Multimedia.Youtube

  @impl true
  def mount(params, session, socket) do
    content_id = params["content_id"]
    concept_id = params["concept_id"]

    if user = session["user_token"] && Accounts.get_user_by_session_token(session["user_token"]) do
      socket =
        socket
          |> assign(current_user: user)
          |> assign(changeset: Multimedia.change_youtube(%Youtube{}))
          |> assign(content_id: content_id)
          |> assign(concept_id: concept_id)

      {:ok, socket}
    else
      {:ok, assign(socket, current_user: nil)}
    end
  end

  @impl true
  def handle_event("validate", %{"youtube" => youtube_params}, socket) do
    changeset =
      %Youtube{}
      |> Multimedia.change_youtube(youtube_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", %{"youtube" => youtube_params}, socket) do
    case Multimedia.create_youtube(youtube_params) do
      {:ok, youtube} ->
        {:noreply,
          socket
            |> put_flash(:info, "Video created successfully!")
            |> push_redirect(to: Routes.concept_show_path(socket, :show, youtube_params["concept_id"]))
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

end
