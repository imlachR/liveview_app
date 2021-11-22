defmodule TriviumWeb.TeaserLive do
  use TriviumWeb, :live_view

  alias Trivium.Accounts

  @impl true
  def mount(params, session, socket) do

    if user = session["user_token"] && Accounts.get_user_by_session_token(session["user_token"]) do

      socket =
        socket
        |> assign(:current_user, user)
        |> assign(:locale, Gettext.put_locale(TriviumWeb.Gettext, user.prefered_language))

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
  def handle_event("user-locale", %{"lang" => lang}, socket) do
    # Gettext.put_locale(TriviumWeb.Gettext, lang)
    {:noreply, socket}
  end

  defp get_first_letter(name) do
    name
    |> String.at(0)
    |> String.upcase
  end

end
