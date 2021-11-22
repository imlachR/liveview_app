defmodule TriviumWeb.SubscriptionLive.FormComponent do
  use TriviumWeb, :live_component

  alias Trivium.Classrooms
  alias Trivium.Classrooms.Subscription

  @impl true
  def update(%{current_user: current_user, classroom: classroom}, socket) do
    socket =
      assign(socket,
        current_user: current_user,
        classroom: classroom,
        changeset: Classrooms.change_subscription(%Subscription{})
      )

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"subscription" => subscription_params}, socket) do
    changeset =
      %Subscription{}
      |> Classrooms.change_subscription(subscription_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", %{"subscription" => subscription_params}, socket) do
    case Classrooms.create_subscription(subscription_params) do
      {:ok, subscription} ->
        {:noreply,
          socket
            |> put_flash(:info, "Subscription created successfully!")
            |> push_redirect(to: Routes.classroom_show_path(socket, :show, socket.assigns.classroom.id))
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

end
