defmodule TriviumWeb.InstitutionLive.Index do
  use TriviumWeb, :live_view

  alias Trivium.Accounts
  alias Trivium.Classrooms
  alias Trivium.Classrooms.Institution

  @impl true
  def mount(_params, session, socket) do
    if user = session["user_token"] && Accounts.get_user_by_session_token(session["user_token"]) do
      socket =
        socket
          |> assign(current_user: user)
          |> assign(institutions: list_institutions())

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
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Institution")
    |> assign(:institution, Classrooms.get_institution!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Institution")
    |> assign(:institution, %Institution{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Institutions")
    |> assign(:institution, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    institution = Classrooms.get_institution!(id)
    {:ok, _} = Classrooms.delete_institution(institution)

    {:noreply, assign(socket, :institutions, list_institutions())}
  end

  defp list_institutions do
    Classrooms.list_institutions()
  end

  defp user_score(user_id) do
    Classrooms.get_student_total_score(user_id)
    |> Enum.map(&(&1.score))
    |> Enum.sum()
  end
end
