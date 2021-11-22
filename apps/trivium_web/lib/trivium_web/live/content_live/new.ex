defmodule TriviumWeb.ContentLive.New do
  use TriviumWeb, :live_view

  alias Trivium.Accounts
  alias Trivium.Classrooms
  alias Trivium.Classrooms.Content

  @impl true
  def mount(params, session, socket) do
    concept_id = params["concept_id"]

    if user = session["user_token"] && Accounts.get_user_by_session_token(session["user_token"]) do
      socket =
        socket
          |> assign(current_user: user)
          |> assign(changeset: Classrooms.change_content(%Content{}))
          |> assign(concept_id: concept_id)

      {:ok, socket}
    else
      {:ok, assign(socket, current_user: nil)}
    end
  end

  @impl true
  def handle_event("validate", %{"content" => content_params}, socket) do
    changeset =
      %Content{}
      |> Classrooms.change_content(content_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", %{"content" => content_params}, socket) do
    case Classrooms.create_content(content_params) do
      {:ok, content} ->
        {:noreply,
          socket
            |> put_flash(:info, "Content created successfully!")
            |> push_redirect(to: Routes.concept_show_path(socket, :show, content_params["concept_id"]))
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

end
