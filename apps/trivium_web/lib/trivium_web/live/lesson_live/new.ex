defmodule TriviumWeb.LessonLive.New do
  use TriviumWeb, :live_view

  alias Trivium.Accounts
  alias Trivium.Classrooms
  alias Trivium.Classrooms.Lesson

  @impl true
  def mount(params, session, socket) do
    subject_id = params["subject_id"]

    if user = session["user_token"] && Accounts.get_user_by_session_token(session["user_token"]) do
      socket =
        socket
          |> assign(current_user: user)
          |> assign(changeset: Classrooms.change_lesson(%Lesson{}))
          |> assign(subject_id: subject_id)

      {:ok, socket}
    else
      {:ok, assign(socket, current_user: nil)}
    end
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
    case Classrooms.create_lesson(lesson_params) do
      {:ok, lesson} ->
        {:noreply,
          socket
            |> put_flash(:info, "Lesson created successfully!")
            |> push_redirect(to: Routes.subject_show_path(socket, :show, lesson_params["subject_id"]))
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

end
