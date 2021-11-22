defmodule TriviumWeb.PageLive do
  use TriviumWeb, :live_view

  alias Trivium.Accounts
  alias Trivium.Classrooms

  @impl true
  def mount(params, session, socket) do
    IO.puts "CONNECTED >>>>> #{inspect(connected?(socket))}"
    if user = session["user_token"] && Accounts.get_user_by_session_token(session["user_token"]) do

      Phoenix.PubSub.subscribe(Trivium.PubSub, "customer" <> ":#{user.id}")

      socket =
        socket
        |> assign(:current_user, user)
        |> assign(:user_score, user_score(user.id))
        |> assign(:user_subscriptions, Classrooms.list_subscriptions_by(user))
        |> assign(:locale, Gettext.put_locale(TriviumWeb.Gettext, user.prefered_language))
        |> assign(:handle, nil)
        |> assign(:current_view, "tasks")

      {:ok, socket}
    else

      socket =
        socket
        |> assign(:current_user, nil)
        |> assign(:locale, session["locale"])

        if session["locale"] != nil do
          Gettext.put_locale(TriviumWeb.Gettext, session["locale"])
        end

      {:ok, socket}
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

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  @impl true
  def handle_info({:handle_not_found, new_handle}, socket) do
    socket =
      socket
      |> put_flash(:error, "No Handle found \"#{new_handle}\"")

    {:noreply, socket}
  end

  @impl true
  def handle_info({:new_current_view, new_view}, socket) do
    {:noreply, assign(socket, current_view: new_view)}
  end

  @impl true
  def handle_info(%{event: "update_student_subscription", payload: subscription}, socket) do
    socket =
      socket
      |> assign(:user_subscriptions, Classrooms.list_subscriptions_by(socket.assigns.current_user))

    {:noreply, socket}
  end

  defp user_score(user_id) do
    Classrooms.get_student_total_score(user_id)
    |> Enum.map(&(&1.score))
    |> Enum.sum()
  end

end
