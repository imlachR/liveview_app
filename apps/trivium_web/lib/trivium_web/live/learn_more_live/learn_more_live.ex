defmodule TriviumWeb.LearnMoreLive do
  use TriviumWeb, :live_view

  alias Trivium.Accounts
  alias Trivium.Classrooms

  @impl true
  def mount(_params, session, socket) do
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

end
