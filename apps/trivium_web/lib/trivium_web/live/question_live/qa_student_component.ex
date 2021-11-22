defmodule TriviumWeb.QaStudentComponent do
  use TriviumWeb, :live_component

  alias Trivium.Classrooms
  alias Trivium.Exercises
  alias Trivium.Exercises.Answer

  @impl true
  def update(%{content: content,
               question: question,
               current_user: current_user,
               user_answered_this_question: user_answered_this_question}, socket) do

    socket =
      socket
      |> assign(:content, content)
      |> assign(:question, question)
      |> assign(:current_user, current_user)
      |> assign(:changeset, Exercises.change_answer(%Answer{}))
      |> assign(:user_answered_this_question, user_answered_this_question)

    {:ok, socket}
  end

  ########
  #
  #  ANSWERS
  #
  ########

  @impl true
  def handle_event("new-student-answer", %{"answer" => answer_params}, socket) do
    case Exercises.create_answer(answer_params) do
      {:ok, student_answer} ->
        TriviumWeb.Endpoint.broadcast!("concepts:#{socket.assigns.content.concept_id}", "student_answer", student_answer)
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

end
