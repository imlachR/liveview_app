defmodule TriviumWeb.LessonLive.Edit do
  use TriviumWeb, :live_view

  alias Trivium.Accounts
  alias Trivium.Classrooms
  alias Trivium.Classrooms.Lesson

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
    lesson = Classrooms.get_lesson!(id)

    {:noreply,
     socket
     |> assign(:lesson, Classrooms.get_lesson!(id))
     |> assign(changeset: Classrooms.change_lesson(lesson))
   }
  end

  @impl true
  def handle_event("validate", %{"lesson" => lesson_params}, socket) do
    changeset =
      %Lesson{}
      |> Classrooms.change_lesson(lesson_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", %{"lesson" => lesson_params}, socket) do
    case Classrooms.update_lesson(socket.assigns.lesson, lesson_params) do
      {:ok, _subject} ->
        {:noreply,
         socket
         |> put_flash(:info, "Lesson updated successfully")
         |> push_redirect(to: Routes.subject_show_path(socket, :show, socket.assigns.lesson.subject.id))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

end
