defmodule TriviumWeb.ProfileLive.Show do
  use TriviumWeb, :live_view

  alias Trivium.Accounts
  alias Trivium.Classrooms

  @impl true
  def mount(params, session, socket) do
    if user = session["user_token"] && Accounts.get_user_by_session_token(session["user_token"]) do
      socket =
        socket
          |> assign(current_user: user)
          |> assign(:locale, Gettext.put_locale(TriviumWeb.Gettext, user.prefered_language))

      {:ok, socket}
    else
      {:ok, assign(socket, current_user: nil)}
    end
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    user = Accounts.get_user!(id)

    {:noreply,
     socket
     |> assign(:user, user)
     |> assign(changeset: Accounts.change_user_registration(user))
    }
  end

  @impl true
  def handle_event("preferred-language", %{"user" => user_params}, socket) do
    user = Accounts.get_user!(socket.assigns.user.id)

    case Accounts.update_user_language(user, user_params) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:info, "Language updated successfully")
         |> push_redirect(to: Routes.profile_show_path(socket, :show, user))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp user_score(user_id) do
    Classrooms.get_student_total_score(user_id)
    |> Enum.map(&(&1.score))
    |> Enum.sum()
  end

end
