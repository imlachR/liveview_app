defmodule TriviumWeb.CrmLive.Edit do
  use TriviumWeb, :live_view

  alias Trivium.Accounts

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
    user = Accounts.get_user!(id)

    {:noreply,
     socket
     |> assign(:user, user)
     |> assign(changeset: Accounts.change_user_registration(user))
   }
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    user = Accounts.get_user!(socket.assigns.user.id)

    case Accounts.update_user_role(user, user_params) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:info, "User updated successfully")
         |> push_redirect(to: Routes.crm_show_path(socket, :show, socket.assigns.user.id))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end

  end

end
