defmodule TriviumWeb.ConceptLive.New do
  use TriviumWeb, :live_view

  alias Trivium.Accounts
  alias Trivium.Classrooms
  alias Trivium.Classrooms.Concept
  alias Trivium.Themes

  @impl true
  def mount(params, session, socket) do
    lesson_id = params["lesson_id"]
    subject_id = params["subject_id"]

    if user = session["user_token"] && Accounts.get_user_by_session_token(session["user_token"]) do
      socket =
        socket
          |> assign(current_user: user)
          |> assign(changeset: Classrooms.change_concept(%Concept{}))
          |> assign(lesson_id: lesson_id)
          |> assign(subject_id: subject_id)

      {:ok, socket}
    else
      {:ok, assign(socket, current_user: nil)}
    end
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
    case Classrooms.create_concept(%{name: concept_params["name"], lesson_id: concept_params["lesson_id"], contents: [%{name: "Add a Title", position: 1}]}) do
      {:ok, concept} ->
        {:noreply,
          socket
            |> put_flash(:info, "Concept created successfully!")
            |> push_redirect(to: Routes.content_show_path(socket, :show, concept, hd(concept.contents)))
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  @impl true
  def handle_event("space-exploration", %{"lesson" => lesson}, socket) do
    lesson_id = String.to_integer(lesson)
    concept = Themes.pt_egypt_predynastic(lesson_id)

    {:noreply,
      socket
        |> put_flash(:info, "Concept created successfully!")
        |> push_redirect(to: Routes.content_show_path(socket, :show, concept, hd(concept.contents).id))
    }
  end

end
