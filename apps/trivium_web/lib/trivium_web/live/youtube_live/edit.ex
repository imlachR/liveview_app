defmodule TriviumWeb.YoutubeLive.Edit do
  use TriviumWeb, :live_view

  alias Trivium.Accounts
  alias Trivium.Multimedia
  alias Trivium.Multimedia.Youtube

  @impl true
  def mount(params, session, socket) do
    if user = session["user_token"] && Accounts.get_user_by_session_token(session["user_token"]) do
      socket =
        socket
          |> assign(current_user: user)

      {:ok, socket}
    else
      {:ok, assign(socket, current_user: nil)}
    end
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    youtube = Multimedia.get_youtube!(id)

    {:noreply,
     socket
     |> assign(:youtube, youtube)
     |> assign(changeset: Multimedia.change_youtube(youtube))
   }
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
    case Multimedia.update_youtube(socket.assigns.youtube, youtube_params) do
      {:ok, _youtube} ->
        {:noreply,
         socket
         |> put_flash(:info, "Youtube video updated successfully")
         |> push_redirect(to: Routes.concept_show_path(socket, :show, socket.assigns.youtube.content.concept_id))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

end
