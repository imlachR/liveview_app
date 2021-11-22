defmodule Trivium.Accounts.UserNotifier do
  import Swoosh.Email
  alias Trivium.Mailer

  @support "support@triviumlms.com"
  @confirmation "confirmation@triviumlms.com"
  @password_reset "passwordreset@triviumlms.com"
  @trivium "Trivium LMS"

  # defp deliver(to, body) do
  #   require Logger
  #   Logger.debug(body)
  #   {:ok, %{to: to, body: body}}
  # end

  defp deliver(to, from, subject, text_body, html_body) do
    email =
      new()
      |> to(to)
      |> from({@trivium, from})
      |> subject(subject)
      |> html_body(html_body)
      |> text_body(text_body)
      |> Mailer.deliver

    {:ok, email}
  end


  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    text_body = """

    ==============================

    Hi #{user.name},

    Your account has been created, click on the link below to get started!

    #{url}

    If you didn't create an account with us, please ignore this.

    ==============================
    """

    html_body = """
    Hi #{user.name},<br/></br/>
    Your account has been created, click on the link below to get started!<br/></br/>
    <a href="#{url}" target="_blank">#{url}</a><br/></br/>
    If you didn't create an account with us, please ignore this.
    """

    deliver({user.name, user.email}, @confirmation, "Welcome to Trivium!", text_body, html_body)
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    text_body = """
    ==============================

    Hi #{user.name},

    You can reset your password by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    """

    html_body = """
    Hi #{user.name},<br/></br/>
    You can reset your password by visiting the url below:
    <a href="#{url}" target="_blank">#{url}</a><br/></br/>
    If you didn't request this change, please ignore this.
    """
    deliver({user.name, user.email}, @password_reset, "Password Reset", text_body, html_body)
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    text_body = """
    ==============================

    Hi #{user.email},

    You can change your e-mail by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """

    html_body = """
    Hi #{user.name},<br/></br/>
    You can change your e-mail by visiting the url below:
    <a href="#{url}" target="_blank">#{url}</a><br/></br/>
    If you didn't request this change, please ignore this.
    """
    deliver({user.name, user.email}, @support, "Update Email Request", text_body, html_body)
  end
end
