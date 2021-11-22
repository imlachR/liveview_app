defmodule TriviumWeb.QaComponent do
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

  ########
  #
  #  ANSWERS
  #
  ########

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
