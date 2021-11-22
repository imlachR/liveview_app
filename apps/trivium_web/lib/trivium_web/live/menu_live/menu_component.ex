defmodule TriviumWeb.MenuComponent do
  use TriviumWeb, :live_component

  alias Trivium.Classrooms

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  defp user_score(user_id) do
    Classrooms.get_student_total_score(user_id)
    |> Enum.map(&(&1.score))
    |> Enum.sum()
  end
end
