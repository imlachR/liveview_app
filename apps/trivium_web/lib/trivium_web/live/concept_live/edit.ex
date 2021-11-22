defmodule TriviumWeb.ConceptLive.Edit do
  use TriviumWeb, :live_view

  alias Trivium.Accounts
  alias Trivium.Classrooms
  alias Trivium.Classrooms.Concept

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
    concept = Classrooms.get_concept!(id)

    {:noreply,
     socket
     |> assign(:concept, Classrooms.get_concept!(id))
     |> assign(changeset: Classrooms.change_concept(concept))
   }
  end

  @impl true
  def handle_event("validate", %{"concept" => concept_params}, socket) do
    changeset =
      %Concept{}
      |> Classrooms.change_concept(concept_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", %{"concept" => concept_params}, socket) do
    case Classrooms.update_concept(socket.assigns.concept, concept_params) do
      {:ok, _concept} ->
        {:noreply,
         socket
         |> put_flash(:info, "Concept updated successfully")
         |> push_redirect(to: Routes.subject_show_path(socket, :show, socket.assigns.concept.lesson.subject.id))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

end
