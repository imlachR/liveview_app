defmodule TriviumWeb.ClassroomLive.New do
  use TriviumWeb, :live_view

  alias Trivium.Accounts
  alias Trivium.Classrooms
  alias Trivium.Classrooms.Classroom

  @impl true
  def mount(params, session, socket) do
    institution_id = params["institution_id"]

    if user = session["user_token"] && Accounts.get_user_by_session_token(session["user_token"]) do
      socket =
        socket
          |> assign(current_user: user)
          |> assign(changeset: Classrooms.change_classroom(%Classroom{}))
          |> assign(institution_id: institution_id)

      {:ok, socket}
    else
      {:ok, assign(socket, current_user: nil)}
    end
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
    case Classrooms.create_classroom(classroom_params) do
      {:ok, classroom} ->
        {:noreply,
          socket
            |> put_flash(:info, "Classroom created successfully!")
            |> push_redirect(to: Routes.classroom_show_path(socket, :show, classroom))
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

end
