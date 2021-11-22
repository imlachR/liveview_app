defmodule TriviumWeb.SubscriptionLive.Edit do
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
    subscription = Classrooms.get_subscription!(id)
    user = Accounts.get_user!(subscription.user_id)

    {:noreply,
     socket
     |> assign(:subscription, subscription)
     |> assign(:user, user)
     |> assign(changeset: Classrooms.change_subscription(subscription))
   }
  end

  @impl true
  def handle_event("save", %{"subscription" => subscription_params}, socket) do
    subscription = Classrooms.get_subscription!(socket.assigns.subscription.id)

    case Classrooms.update_subscription(subscription, subscription_params) do
      {:ok, _subscription} ->
        {:noreply,
         socket
         |> put_flash(:info, "Subscription updated successfully")
         |> push_redirect(to: Routes.classroom_show_path(socket, :show, socket.assigns.subscription.classroom_id))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end

  end

end
