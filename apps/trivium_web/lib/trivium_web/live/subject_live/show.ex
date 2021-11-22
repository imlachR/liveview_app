defmodule TriviumWeb.SubjectLive.Show do
  use TriviumWeb, :live_view

  alias Trivium.Accounts
  alias Trivium.Classrooms

  @impl true
  def mount(params, session, socket) do
    if user = session["user_token"] && Accounts.get_user_by_session_token(session["user_token"]) do

      subject = Classrooms.get_subject_simple!(params["id"])
      classroom_id = subject.classroom_id

      socket =
        socket
          |> assign(current_user: user)

      if user.role == "root" || user.role == "sales" do
        {:ok, socket}
      else
        if Accounts.access_policy_for_staff(user, classroom_id) != [] do
          {:ok, socket}
        else
          {:ok,
            socket
            |> put_flash(:error, "You are not Authorized!")
            |> redirect(to: "/")
          }
        end
      end

    else
      {:ok, assign(socket, current_user: nil)}
    end
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    subject = Classrooms.get_subject!(id)

    {:noreply,
      socket
      |> assign(:subject, subject)
    }
  end

  @impl true
  def handle_event("delete-lesson", %{"id" => id}, socket) do
    lesson = Classrooms.get_lesson!(id)
    {:ok, _} = Classrooms.delete_lesson(lesson)

    socket =
      socket
      |> assign(:subject, socket.assigns.ubject)

    {:noreply, socket}
  end

  @impl true
  def handle_event("delete-concept", %{"id" => id}, socket) do
    concept = Classrooms.get_concept!(id)
    {:ok, _} = Classrooms.delete_concept(concept)

    socket =
      socket
      |> assign(:subject, socket.assigns.ubject)

    {:noreply, socket}
  end

  defp list_lessons(subject) do
    Classrooms.list_lessons_by_subject(subject)
  end

  defp list_concepts(lesson) do
    Classrooms.list_concepts_by_lesson(lesson)
  end

  defp get_first_content(concept) do
    Classrooms.all_contents_by_concept(concept)
    |> Enum.map(&(&1.id))
    |> List.first()
  end

  defp current_user_classrooms_ids(collection) do
    collection
    |> Enum.map(&(&1.id)) # get a list
  end

  defp user_score(user_id) do
    Classrooms.get_student_total_score(user_id)
    |> Enum.map(&(&1.score))
    |> Enum.sum()
  end

  defp get_3_letters(name) do
    name
    |> String.replace(" ", "")
    |> String.slice(0..2)
    |> String.capitalize()
  end
end
