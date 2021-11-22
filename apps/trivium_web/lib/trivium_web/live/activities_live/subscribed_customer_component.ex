defmodule TriviumWeb.SubscribedCustomerComponent do
  use TriviumWeb, :live_component

  alias Trivium.Accounts
  alias Trivium.Classrooms

  @impl true
  def update(%{current_user: current_user, user_subscriptions: user_subscriptions}, socket) do
    selected_subscription = List.first(user_subscriptions)
    selected_classroom = Classrooms.get_classroom_simple!(selected_subscription.classroom_id)

    socket =
      socket
      |> assign(:current_user, current_user)
      |> assign(:user_subscriptions, user_subscriptions)
      |> assign(:selected_subscription, selected_subscription)
      |> assign(:selected_classroom, selected_classroom)
      |> assign(:current_view, "tasks")
      |> assign(:concepts, get_user_tasks(current_user, selected_classroom))
      |> assign(:completeds, get_user_done_tasks(current_user.id, selected_classroom.id))
      |> assign(:subjects, subjects_from(selected_classroom))
      |> assign(:selected_subject, "all")

    {:ok, socket}
  end

  ###########
  #
  #  CLASSROOM COLLECTION
  #
  ###############

  defp get_classroom_info_by(classroom_id) do
    Classrooms.get_classroom_name_by(classroom_id)
  end

  ###########
  #
  #  SELECT A CLASSROOM
  #
  ###############

  @impl true
  def handle_event("select-classroom", %{"sub" => sub, "classroom" => classroom}, socket) do
    classroom = Classrooms.get_classroom_simple!(classroom)

    socket =
      socket
      |> assign(:selected_subscription, Classrooms.get_subscription!(sub))
      |> assign(:selected_classroom, classroom)
      |> assign(:current_view, "tasks")
      |> assign(:subjects, subjects_from(classroom))
      |> assign(:selected_subject, "all")
      |> assign(:concepts, get_user_tasks(socket.assigns.current_user, classroom))
      |> assign(:completeds, get_user_done_tasks(socket.assigns.current_user.id, classroom.id))

    {:noreply, socket}
  end

  @impl true
  def handle_event("go-to-tasks", %{"id" => id}, socket) do
    classroom = Classrooms.get_classroom_simple!(id)

    socket =
      socket
      |> assign(:selected_classroom, classroom)
      |> assign(:current_view, "tasks")
      |> assign(:subjects, subjects_from(classroom))
      |> assign(:selected_subject, "all")

    {:noreply, socket}
  end

  @impl true
  def handle_event("go-to-done", %{"id" => id}, socket) do
    classroom = Classrooms.get_classroom_simple!(id)

    socket =
      socket
      |> assign(:selected_classroom, classroom)
      |> assign(:current_view, "done")
      |> assign(:subjects, subjects_from(classroom))
      |> assign(:selected_subject, "all")

    {:noreply, socket}
  end

  ###########
  #
  #  SELECTED CLASSROOM SUBJECTS FUNCTIONS
  #
  ###############

  @impl true
  def handle_event("select-subject-all", _, socket) do
    socket =
      assign(socket,
        selected_subject: "all"
      )

    {:noreply, socket}
  end

  @impl true
  def handle_event("select-subject", %{"subject" => subject}, socket) do
    socket =
      assign(socket,
        selected_subject: subject
      )

    {:noreply, socket}
  end

  defp subjects_from(selected_classroom) do
    Classrooms.get_classroom_subjects(selected_classroom)
  end

  defp retrieve_subject_from(concept) do
    lesson_id = concept.lesson_id
    Classrooms.get_subject_from_concept(lesson_id)
  end

  ###########
  #
  # CURRENT USER TASKS BY SELECTED CLASSROOM 
  #
  ###############

  defp get_user_tasks(user, classroom) do
    user_progresses = Accounts.user_progresses(user)
    |> Enum.map(&(&1.concept_id))

    Classrooms.list_concepts_by(classroom, user_progresses)
  end

  defp get_user_done_tasks(user_id, classroom_id) do
    Classrooms.list_done_tasks_by_user_progress_and_classroom(user_id, classroom_id)
  end

  ###########
  #
  # CARD FUNCTIONS
  #
  ###############

  defp get_3_letters(name) do
    name
    |> String.replace(" ", "")
    |> String.slice(0..4)
    |> String.capitalize()
  end

  defp get_first_content(concept) do
    Classrooms.all_contents_by_concept(concept)
    |> Enum.map(&(&1.id))
    |> List.first()
  end

end
