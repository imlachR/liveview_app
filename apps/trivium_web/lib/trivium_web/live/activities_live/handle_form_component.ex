defmodule TriviumWeb.HandleFormComponent do
  use TriviumWeb, :live_component

  alias Trivium.Classrooms

  @impl true
  def update(%{current_user: current_user, handle: handle}, socket) do
    socket =
      socket
      |> assign(:current_user, current_user)
      |> assign(:handle, handle)

    {:ok, socket}
  end

  @impl true
  def handle_event("subscribe-by-handle", %{"handle" => handle, "user_id" => user_id}, socket) do
    new_handle = handle

    case Classrooms.search_by_handle(new_handle) do
      [] ->
        send(self(), {:handle_not_found, new_handle})
        {:noreply, socket}

      classrooms ->
        get_classroom_id_by_handle = hd(classrooms).id
        send(self(), {:subscribe_to_handle, get_classroom_id_by_handle, user_id})
        {:noreply, socket}
    end

    # {:noreply, socket}
  end

  defp first_name(name) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end
end
