defmodule TriviumWeb.SubjectLive.Edit do
  use TriviumWeb, :live_view

  alias Trivium.Accounts
  alias Trivium.Classrooms
  alias Trivium.Classrooms.Subject

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
    subject = Classrooms.get_subject!(id)

    {:noreply,
     socket
     |> assign(:subject, Classrooms.get_subject!(id))
     |> assign(changeset: Classrooms.change_subject(subject))
   }
  end

  @impl true
  def handle_event("validate", %{"subject" => subject_params}, socket) do
    changeset =
      %Subject{}
      |> Classrooms.change_subject(subject_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", %{"subject" => subject_params}, socket) do
    case Classrooms.update_subject(socket.assigns.subject, subject_params) do
      {:ok, _subject} ->
        {:noreply,
         socket
         |> put_flash(:info, "Subject updated successfully")
         |> push_redirect(to: Routes.classroom_show_path(socket, :show, socket.assigns.subject.classroom.id))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

end
