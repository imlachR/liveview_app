defmodule TriviumWeb.QuestionLive.Edit do
  use TriviumWeb, :live_view

  alias Trivium.Accounts
  alias Trivium.Exercises
  alias Trivium.Exercises.Question

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
    question = Exercises.get_question!(id)

    {:noreply,
     socket
     |> assign(:question, Exercises.get_question!(id))
     |> assign(changeset: Exercises.change_question(question))
   }
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
    case Exercises.update_question(socket.assigns.question, question_params) do
      {:ok, _question} ->
        {:noreply,
         socket
         |> put_flash(:info, "Question updated successfully")
         |> push_redirect(to: Routes.concept_show_path(socket, :show, socket.assigns.question.content.concept_id))
       }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

end
