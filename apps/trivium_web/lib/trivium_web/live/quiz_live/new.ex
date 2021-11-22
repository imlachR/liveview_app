defmodule TriviumWeb.QuizLive.New do
  use TriviumWeb, :live_view

  alias Trivium.Accounts
  alias Trivium.Exercises
  alias Trivium.Exercises.{Question, Quiz}

  @impl true
  def mount(params, session, socket) do
    content_id = params["content_id"]
    concept_id = params["concept_id"]

    question = get_question(session)
    changeset =
      Exercises.change_question(question)
      |> Ecto.Changeset.put_assoc(:quizzes, question.quizzes)

    if user = session["user_token"] && Accounts.get_user_by_session_token(session["user_token"]) do
      socket =
        socket
          |> assign(current_user: user)
          |> assign(changeset: changeset)
          |> assign(question: question)
          |> assign(content_id: content_id)
          |> assign(concept_id: concept_id)

      {:ok, socket}
    else
      {:ok, assign(socket, current_user: nil)}
    end
  end

  @impl true
  def handle_event("validate", %{"question" => question_params}, socket) do
    changeset =
      %Question{}
      |> Exercises.change_question(question_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", %{"question" => question_params}, socket) do
    case Exercises.create_question(question_params) do
      {:ok, question} ->
        {:noreply,
          socket
            |> put_flash(:info, "Quiz created successfully!")
            |> push_redirect(to: Routes.concept_show_path(socket, :show, question_params["concept_id"]))
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  @impl true
  def handle_event("add-quiz", _, socket) do
    existing_quizzes = Map.get(socket.assigns.changeset.changes, :quizzes, socket.assigns.question.quizzes)

    quizzes =
      existing_quizzes 
      |> Enum.concat([
        Exercises.change_quiz(%Quiz{temp_id: get_temp_id()})
        ])

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:quizzes, quizzes)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("remove-quiz", %{"remove" => remove_id}, socket) do
    quizzes =
      socket.assigns.changeset.changes.quizzes
      |> Enum.reject(fn %{data: quiz} ->
        quiz.temp_id == remove_id
      end)

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:quizzes, quizzes)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def get_question(_question_params), do: %Question{quizzes: []}
  defp get_temp_id, do: :crypto.strong_rand_bytes(5) |> Base.url_encode64 |> binary_part(0, 5)



















end
