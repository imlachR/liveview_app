defmodule TriviumWeb.CrmLive.Show do
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
    }
  end
end
