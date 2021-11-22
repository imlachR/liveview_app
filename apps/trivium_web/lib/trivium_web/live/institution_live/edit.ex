defmodule TriviumWeb.InstitutionLive.Edit do
  use TriviumWeb, :live_view

  alias Trivium.Accounts
  alias Trivium.Classrooms
  alias Trivium.Classrooms.Institution

  @impl true
  def mount(params, session, socket) do
    if user = session["user_token"] && Accounts.get_user_by_session_token(session["user_token"]) do
      socket =
        socket
          |> assign(current_user: user)

      if socket.assigns.current_user.role == "root" || socket.assigns.current_user.role == "sales" do
        {:ok, socket}
      else
        {:ok,
          socket
          |> put_flash(:error, "You are not Authorized!")
          |> redirect(to: "/")
        }
      end
    else
      {:ok, assign(socket, current_user: nil)}
    end
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    institution = Classrooms.get_institution!(id)

    {:noreply,
     socket
     |> assign(:institution, Classrooms.get_institution!(id))
     |> assign(changeset: Classrooms.change_institution(institution))
   }
  end

  @impl true
  def handle_event("validate", %{"institution" => institution_params}, socket) do
    changeset =
      %Institution{}
      |> Classrooms.change_institution(institution_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", %{"institution" => institution_params}, socket) do
    case Classrooms.update_institution(socket.assigns.institution, institution_params) do
      {:ok, _institution} ->
        {:noreply,
         socket
         |> put_flash(:info, "Institution updated successfully")
         |> push_redirect(to: Routes.institution_index_path(socket, :index))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

end
