defmodule TriviumWeb.FrameLive.New do
  use TriviumWeb, :live_view

  alias Trivium.Accounts
  alias Trivium.Multimedia
  alias Trivium.Multimedia.Frame

  @impl true
  def mount(params, session, socket) do
    content_id = params["content_id"]
    concept_id = params["concept_id"]

    if user = session["user_token"] && Accounts.get_user_by_session_token(session["user_token"]) do
      socket =
        socket
          |> assign(current_user: user)
          |> assign(changeset: Multimedia.change_frame(%Frame{}))
          |> assign(content_id: content_id)
          |> assign(concept_id: concept_id)

      {:ok, socket}
    else
      {:ok, assign(socket, current_user: nil)}
    end
  end

  @impl true
  def handle_event("validate", %{"frame" => frame_params}, socket) do
    changeset =
      %Frame{}
      |> Multimedia.change_frame(frame_params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", %{"frame" => frame_params}, socket) do
    case Multimedia.create_frame(frame_params) do
      {:ok, frame} ->
        {:noreply,
          socket
            |> put_flash(:info, "Frame created successfully!")
            |> push_redirect(to: Routes.concept_show_path(socket, :show, frame_params["concept_id"]))
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

end
