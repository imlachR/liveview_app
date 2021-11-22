defmodule TriviumWeb.CanvasLive.Index do
  use TriviumWeb, :live_view

  alias Trivium.Accounts
  
  @impl true
  def mount(_params, session, socket) do
    if user = session["user_token"] && Accounts.get_user_by_session_token(session["user_token"]) do
      socket =
        socket
          |> assign(current_user: user)

      {:ok, socket}
    else
      {:ok, assign(socket, current_user: nil)}
    end
  end

  defp get_first_letter(name) do
    name
    |> String.at(0)
    |> String.upcase
  end
end
