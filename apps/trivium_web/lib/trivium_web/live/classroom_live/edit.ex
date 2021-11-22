defmodule TriviumWeb.ClassroomLive.Edit do
  use TriviumWeb, :live_view

  alias Trivium.Accounts
  alias Trivium.Classrooms
  alias Trivium.Classrooms.Classroom

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
    classroom = Classrooms.get_classroom!(id)

    {:noreply,
     socket
     |> assign(:classroom, Classrooms.get_classroom!(id))
     |> assign(changeset: Classrooms.change_classroom(classroom))
   }
  end

  @impl true
  def handle_event("validate", %{"classroom" => classroom_params}, socket) do
    changeset =
      %Classroom{}
      |> Classrooms.change_classroom(classroom_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", %{"classroom" => classroom_params}, socket) do
    case Classrooms.update_classroom(socket.assigns.classroom, classroom_params) do
      {:ok, _classroom} ->
        {:noreply,
         socket
         |> put_flash(:info, "Classroom updated successfully")
         |> push_redirect(to: Routes.institution_show_path(socket, :show, socket.assigns.classroom.institution.id))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

end
