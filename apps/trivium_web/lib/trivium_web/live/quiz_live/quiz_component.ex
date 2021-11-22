defmodule TriviumWeb.QuizComponent do
  use TriviumWeb, :live_component

  alias Trivium.Classrooms
  alias Trivium.Exercises
  alias Trivium.Exercises.Answer

  @impl true
  def update(%{content: content,
               question: question,
               edit_mode: edit_mode,
               contenteditable: contenteditable}, socket) do

    socket =
      socket
      |> assign(:content, content)
      |> assign(:question, question)
      |> assign(:edit_mode, edit_mode)
      |> assign(:contenteditable, contenteditable)

    {:ok, socket}
  end

  @impl true
  def handle_event("position-question-up", %{"id" => id}, socket) do
    question = Exercises.get_question!(id)
    new_position = question.position + 1

    {:ok, _question} =
      Exercises.update_question(
        question,
        %{position: new_position}
      )

    send(self(), {:update_resource})
    {:noreply, socket}
  end

  @impl true
  def handle_event("position-question-down", %{"id" => id}, socket) do
    question = Exercises.get_question!(id)
    new_position = max(question.position - 1, 1)

    {:ok, _question} =
      Exercises.update_question(
        question,
        %{position: new_position}
      )

    send(self(), {:update_resource})
    {:noreply, socket}
  end


  @impl true
  def handle_event("delete-qa", %{"id" => id}, socket) do
    question = Exercises.get_question!(id)
    {:ok, _} = Exercises.delete_question(question)

    send(self(), {:update_resource})
    {:noreply, socket}
  end

  @impl true
  def handle_event("add-a-quiz", %{"question" => question}, socket) do
    text = (gettext "Type an answer")
    question_id =  String.to_integer(question)

    case Exercises.create_quiz(%{quiz_text: text, question_id: question_id}) do
      {:ok, _quiz} ->
        send(self(), {:update_resource})
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def handle_event("delete-a-quiz", %{"quiz" => quiz}, socket) do
    quiz_id = String.to_integer(quiz)
    quiz = Exercises.get_quiz!(quiz_id)
    {:ok, _} = Exercises.delete_quiz(quiz)

    send(self(), {:update_resource})
    {:noreply, socket}
  end

  @impl true
  def handle_event("quiz-marked-as-correct", %{"quiz" => quiz}, socket) do
    quiz_id = String.to_integer(quiz)
    quiz = Exercises.get_quiz!(quiz_id)

    {:ok, _quiz} =
      Exercises.update_quiz(
        quiz,
        %{correct_quiz: true}
      )

    send(self(), {:update_resource})
    {:noreply, socket}
  end

  @impl true
  def handle_event("quiz-marked-as-incorrect", %{"quiz" => quiz}, socket) do
    quiz_id = String.to_integer(quiz)
    quiz = Exercises.get_quiz!(quiz_id)

    {:ok, _quiz} =
      Exercises.update_quiz(
        quiz,
        %{correct_quiz: false}
      )

    send(self(), {:update_resource})
    {:noreply, socket}
  end

  @impl true
  def handle_event("reset-this-quiz", %{"quiz" => quiz}, socket) do
    quiz_id = String.to_integer(quiz)
    quiz = Exercises.get_quiz!(quiz_id)

    {:ok, _quiz} =
      Exercises.update_quiz(
        quiz,
        %{correct_quiz: false}
      )

    send(self(), {:update_resource})
    {:noreply, socket}
  end

  ########
  #
  #  ANSWERS
  #
  ########
  # @impl true
  # def handle_event("quiz-an-answer",
  #                   %{"quiz_id" => quiz_id,
  #                   "score" => score,
  #                   "question_id" => question_id,
  #                   "user_id" => user_id}, socket) do
  #
  #   quiz = Exercises.get_quiz!(quiz_id)
  #   what_the_score = if quiz.correct_quiz == true, do: score, else: "0"
  #   quiz_params = %{answer_text: quiz.quiz_text, score: what_the_score, question_id: question_id, user_id: user_id}
  #
  #   case Exercises.create_answer(quiz_params) do
  #     {:ok, student_answer} ->
  #       TriviumWeb.Endpoint.broadcast!("concepts:#{socket.assigns.content.concept_id}", "student_answer", student_answer)
  #       {:noreply, socket}
  #
  #     {:error, changeset} ->
  #       {:noreply, assign(socket, :changeset, changeset)}
  #   end
  # end

  # @impl true
  # def handle_event("new-student-answer", %{"answer" => answer_params}, socket) do
  #   case Exercises.create_answer(answer_params) do
  #     {:ok, student_answer} ->
  #       TriviumWeb.Endpoint.broadcast!("concepts:#{socket.assigns.content.concept_id}", "student_answer", student_answer)
  #       {:noreply, socket}
  #
  #     {:error, changeset} ->
  #       {:noreply, assign(socket, :changeset, changeset)}
  #   end
  # end

  @impl true
  def handle_event("delete-answer", %{"id" => id}, socket) do
    answer = Exercises.get_answer!(id)
    {:ok, _} = Exercises.delete_answer(answer)
    # TriviumWeb.Endpoint.broadcast!("concepts:#{socket.assigns.content.concept_id}", "answer_to_be_deleted", answer)
    send(self(), {:update_exercises})
    {:noreply, socket}
  end

  @impl true
  def handle_event("right-answer", %{"id" => id}, socket) do
    answer = Exercises.get_answer!(id)

    {:ok, _answer} =
      Exercises.update_answer(
        answer,
        %{score: 10}
      )

    send(self(), {:update_exercises})
    {:noreply, socket}
  end

  @impl true
  def handle_event("wrong-answer", %{"id" => id}, socket) do
    answer = Exercises.get_answer!(id)

    {:ok, _answer} =
      Exercises.update_answer(
        answer,
        %{score: 0}
      )

      send(self(), {:update_exercises})
      {:noreply, socket}
  end

  @impl true
  def handle_event("answer-teacher-reset", %{"id" => id}, socket) do
    answer = Exercises.get_answer!(id)

    {:ok, _answer} =
      Exercises.update_answer(
        answer,
        %{score: nil}
      )

    send(self(), {:update_exercises})
    {:noreply, socket}
  end


end
