defmodule TriviumWeb.InstitutionLive.Show do
  use TriviumWeb, :live_view

  alias Trivium.Accounts
  alias Trivium.Classrooms

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
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:institution, Classrooms.get_institution!(id))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    classroom = Classrooms.get_classroom!(id)
    {:ok, _} = Classrooms.delete_classroom(classroom)

    {:noreply, assign(socket, :institution, Classrooms.get_institution!(socket.assigns.institution.id))}
  end

  defp page_title(:show), do: "Show Institution"
  defp page_title(:edit), do: "Edit Institution"

  defp user_score(user_id) do
    Classrooms.get_student_total_score(user_id)
    |> Enum.map(&(&1.score))
    |> Enum.sum()
  end

  defp get_3_letters(name) do
    String.slice(name, 0..2)
  end
end
