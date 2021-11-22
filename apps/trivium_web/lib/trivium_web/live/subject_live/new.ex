defmodule TriviumWeb.SubjectLive.New do
  use TriviumWeb, :live_view

  alias Trivium.Accounts
  alias Trivium.Classrooms
  alias Trivium.Classrooms.Subject

  @impl true
  def mount(params, session, socket) do
    classroom = Classrooms.get_classroom_simple!(params["classroom_id"])

    if user = session["user_token"] && Accounts.get_user_by_session_token(session["user_token"]) do
      socket =
        socket
          |> assign(current_user: user)
          |> assign(changeset: Classrooms.change_subject(%Subject{}))
          |> assign(classroom: classroom)
          |> assign(classroom_id: classroom.id)

      {:ok, socket}
    else
      {:ok, assign(socket, current_user: nil)}
    end
  end

  @impl true
  def handle_event("validate", %{"subject" => subject_params}, socket) do
    changeset =
      %Subject{}
      |> Classrooms.change_subject(subject_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", %{"subject" => subject_params}, socket) do

    case Classrooms.create_subject(subject_params) do
      {:ok, subject} ->
        {:noreply,
          socket
            |> put_flash(:info, "Subject created successfully!")
            |> push_redirect(to: Routes.classroom_show_path(socket, :show, socket.assigns.classroom))
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

end
