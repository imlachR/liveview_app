defmodule TriviumWeb.SubscriptionLive.New do
  use TriviumWeb, :live_view

  alias Trivium.Accounts
  alias Trivium.Classrooms
  alias Trivium.Classrooms.Subscription

  @impl true
  def mount(params, session, socket) do
    if user = session["user_token"] && Accounts.get_user_by_session_token(session["user_token"]) do
      socket =
        socket
          |> assign(current_user: user)
          |> assign(found: nil)
          |> assign(handle: nil)

      {:ok, socket}
    else
      {:ok, assign(socket, current_user: nil)}
    end
  end

  @impl true
  def handle_event("new-subscription", %{"handle" => handle}, socket) do
    new_handle = handle
    user_id = socket.assigns.current_user.id

    case Classrooms.search_by_handle(new_handle) do
      [] ->
        {:noreply,
          socket
            |> assign(:found, "Not found, try again")
        }

      classrooms ->
        get_classroom_id_by_handle = hd(classrooms).id
        send(self(), {:subscribe_to_handle, get_classroom_id_by_handle, user_id})
        {:noreply, socket}
    end
  end

  @impl true
  def handle_info({:subscribe_to_handle, get_classroom_id_by_handle, user_id}, socket) do
    case Classrooms.create_subscription(%{classroom_id: get_classroom_id_by_handle, user_id: user_id}) do
      {:ok, subscription} ->
        {:noreply,
          socket
            |> put_flash(:info, "Sua conta foi configurada com sucesso!")
            |> push_redirect(to: "/")
        }

      {:error, _reason} ->
        {:noreply,
          socket
            |> assign(:found, "You are already subscribed to this classroom")
        }
    end
  end

end
