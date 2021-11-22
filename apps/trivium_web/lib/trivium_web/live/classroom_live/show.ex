defmodule TriviumWeb.ClassroomLive.Show do
  use TriviumWeb, :live_view

  alias Trivium.Accounts
  alias Trivium.Classrooms

  @impl true
  def mount(params, session, socket) do
    if user = session["user_token"] && Accounts.get_user_by_session_token(session["user_token"]) do
      classroom_id = params["id"]

      Phoenix.PubSub.subscribe(Trivium.PubSub, "classrooms" <> ":#{params["id"]}")

      socket =
        socket
          |> assign(:current_user, user)

      if user.role == "root" || user.role == "sales" do
        {:ok, socket}
      else
        if Accounts.access_policy_for_staff(user, classroom_id) != [] do
          {:ok, socket}
        else
          {:ok,
            socket
            |> put_flash(:error, "You are not Authorized!")
            |> redirect(to: "/")
          }
        end
      end

    else
      {:ok, assign(socket, current_user: nil)}
    end
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    classroom = Classrooms.get_classroom!(id)

    {:noreply,
     socket
     |> assign(:classroom, classroom)
     |> assign(:admissions, Classrooms.list_subscriptions_by_classroom_admissions(classroom))
     |> assign(:requests, Classrooms.list_subscriptions_by_classroom_requests(classroom))
     |> assign(:subjects, Classrooms.list_subjects_by_classroom(classroom))
     |> assign(:current_view, "subjects")
    }
  end

  ###########
  #
  #  ACCEPT SUBSCRIPTION
  #
  ###############

  @impl true
  def handle_event("accept-subscription", %{"id" => id}, socket) do
    subscription = Classrooms.get_subscription!(id)

    {:ok, _subscription} =
      Classrooms.update_subscription(
        subscription,
        %{accepted: true}
      )

    TriviumWeb.Endpoint.broadcast!("classrooms" <> ":#{subscription.classroom_id}", "accepted_student", subscription)
    TriviumWeb.Endpoint.broadcast!("customer" <> ":#{subscription.user_id}", "update_student_subscription", subscription)
    {:noreply, socket}
  end

  @impl true
  def handle_info(%{event: "accepted_student", payload: subscription}, socket) do
    {:noreply,
      socket
      |> assign(:current_view, "request")
      |> assign(:admissions, Classrooms.list_subscriptions_by_classroom_admissions(socket.assigns.classroom))
      |> assign(:requests, Classrooms.list_subscriptions_by_classroom_requests(socket.assigns.classroom))
    }
  end

  ###########
  #
  #  REMOVE SUBSCRIPTION
  #
  ###############

  @impl true
  def handle_event("move-to-requests", %{"id" => id}, socket) do
    subscription = Classrooms.get_subscription!(id)

    {:ok, _subscription} =
      Classrooms.update_subscription(
        subscription,
        %{accepted: false}
      )

    TriviumWeb.Endpoint.broadcast!("classrooms" <> ":#{subscription.classroom_id}", "moved_to_requests", subscription)
    TriviumWeb.Endpoint.broadcast!("customer" <> ":#{subscription.user_id}", "update_student_subscription", subscription)
    {:noreply, socket}
  end

  @impl true
  def handle_info(%{event: "moved_to_requests", payload: subscription}, socket) do
    {:noreply,
      socket
      |> assign(:current_view, "students")
      |> assign(:admissions, Classrooms.list_subscriptions_by_classroom_admissions(socket.assigns.classroom))
      |> assign(:requests, Classrooms.list_subscriptions_by_classroom_requests(socket.assigns.classroom))
    }
  end

  ###########
  #
  #  OTHER SUBSCRIPTION (NOT IMPLEMENTED YET)
  #
  ###############


  @impl true
  def handle_info(%{event: "subscribed_student", payload: subscription}, socket) do
    {:noreply,
      socket
      |> assign(:admissions, Classrooms.list_subscriptions_by_classroom_admissions(socket.assigns.classroom))
    }
  end

  ###########
  #
  #  DELETE SUBSCRIPTION
  #
  ###############

  @impl true
  def handle_event("delete-subscription", %{"id" => id}, socket) do
    subscription = Classrooms.get_subscription!(id)
    {:ok, _} = Classrooms.delete_subscription(subscription)

    {:noreply,
      socket
      |> push_redirect(to: Routes.classroom_show_path(socket, :show, socket.assigns.classroom.id))
    }
  end

  ###########
  #
  #  FILTER SUBSCRIPTIONS
  #
  ###############

  defp students_accepted(collection) do
    collection
    |> Enum.filter(fn(subscription) -> subscription.accepted == true end)
  end

  defp students_request(collection) do
    collection
    |> Enum.filter(fn(subscription) -> subscription.accepted == false end)
  end

  ###########
  #
  #  SUBJECTS
  #
  ###############


  @impl true
  def handle_event("delete-subject", %{"id" => id}, socket) do
    subject = Classrooms.get_subject!(id)
    {:ok, _} = Classrooms.delete_subject(subject)

    socket =
      socket
      |> assign(:classroom, socket.assigns.classroom)

    {:noreply, socket}
  end

  ###########
  #
  #  CURRENT VIEW
  #
  ###############

  @impl true
  def handle_event("go-to-subjects", _, socket) do
    socket =
      assign(socket,
        current_view: "subjects",
      )

    {:noreply, socket}
  end

  @impl true
  def handle_event("go-to-students", _, socket) do
    socket =
      assign(socket,
        current_view: "students",
      )

    {:noreply, socket}
  end

  @impl true
  def handle_event("go-to-request", _, socket) do
    socket =
      assign(socket,
        current_view: "request",
      )

    {:noreply, socket}
  end

  ###########
  #
  #  DEFP
  #
  ###############

  # defp get_students(collection) do
  #   collection
  #   |> Enum.filter(fn(user) -> user.role == "customer" end)
  # end
  #
  # defp get_teachers(collection) do
  #   collection
  #   |> Enum.filter(fn(user) -> user.role == "customer" end)
  # end

  ###########
  #
  #  SCORES
  #
  ###############

  defp user_score(user_id) do
    Classrooms.get_student_total_score(user_id)
    |> Enum.map(&(&1.score))
    |> Enum.sum()
  end

  defp user_score_by_classroom(user, classroom_id) do
    Classrooms.get_student_score_by_classroom(user, classroom_id)
    # |> Enum.map(&(&1.score))
    # |> Enum.sum()
  end

  ###########
  #
  #  CARDS
  #
  ###############

  defp get_3_letters(name) do
    String.slice(name, 0..2)
  end
end
