defmodule TriviumWeb.DashComponent do
  use TriviumWeb, :live_component

  @impl true
  def update(%{current_user: current_user}, socket) do
    socket =
      socket
      |> assign(current_user: current_user)

    {:ok, socket}
  end

  defp first_name(name) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end
end
