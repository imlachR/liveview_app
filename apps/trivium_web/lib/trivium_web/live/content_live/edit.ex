defmodule TriviumWeb.ContentLive.Edit do
  use TriviumWeb, :live_view

  alias Trivium.Accounts
  alias Trivium.Classrooms
  alias Trivium.Classrooms.Content

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
    content = Classrooms.get_content!(id)

    {:noreply,
     socket
     |> assign(:content, content)
     |> assign(changeset: Classrooms.change_content(content))
   }
  end

  @impl true
  def handle_event("validate", %{"content" => content_params}, socket) do
    changeset =
      %Content{}
      |> Classrooms.change_content(content_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", %{"content" => content_params}, socket) do
    case Classrooms.update_content(socket.assigns.content, content_params) do
      {:ok, _content} ->
        {:noreply,
         socket
         |> put_flash(:info, "Content updated successfully")
         |> push_redirect(to: Routes.concept_show_path(socket, :show, socket.assigns.content.concept.id))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

end
