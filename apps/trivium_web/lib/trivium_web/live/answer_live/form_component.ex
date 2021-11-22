defmodule TriviumWeb.AnswerLive.FormComponent do
  use TriviumWeb, :live_component

  alias Trivium.Exercises
  alias Trivium.Classrooms

  @impl true
  def update(%{answer: answer} = assigns, socket) do
    changeset = Exercises.change_answer(answer)

    {:ok,
      socket
      |> assign(assigns)
      |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"answer" => answer_params}, socket) do
    changeset =
      socket.assigns.answer
      |> Exercises.change_answer(answer_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"answer" => answer_params}, socket) do
    case Exercises.create_answer(answer_params) do
      {:ok, answer} ->
        send(self(), {:updated_answer, answer})

        {:noreply,
         socket
         |> put_flash(:info, "Answer created successfully")
         |> push_patch(to: Routes.concept_show_path(socket, :show, 1))}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  # @impl true
  # def handle_event("save", %{"answer" => answer_params}, socket) do
  #   selected = answer_params["selected"]
  #
  #   case Exercises.create_answer(answer_params) do
  #     {:ok, answer} ->
  #       {:noreply,
  #         socket
  #         |> put_flash(:info, "Answer created successfully")
  #         |> push_patch(to: Routes.live_path(socket, __MODULE__, selected: Classrooms.get_content!(selected)))
  #       }
  #
  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       {:noreply, assign(socket, changeset: changeset)}
  #   end
  # end

end
