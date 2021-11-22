defmodule TriviumWeb.FrameLive.Edit do
  use TriviumWeb, :live_view

  alias Trivium.Accounts
  alias Trivium.Multimedia
  alias Trivium.Multimedia.Frame

  @impl true
  def mount(params, session, socket) do
    if user = session["user_token"] && Accounts.get_user_by_session_token(session["user_token"]) do
      socket =
        socket
          |> assign(current_user: user)

      {:ok, socket}
    else
      {:ok, assign(socket, current_user: nil)}
    end
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    frame = Multimedia.get_frame!(id)

    {:noreply,
     socket
     |> assign(:frame, frame)
     |> assign(changeset: Multimedia.change_frame(frame))
   }
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
    case Multimedia.update_frame(socket.assigns.frame, frame_params) do
      {:ok, _frame} ->
        {:noreply,
         socket
         |> put_flash(:info, "iframe video updated successfully")
         |> push_redirect(to: Routes.concept_show_path(socket, :show, socket.assigns.frame.content.concept_id))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

end
