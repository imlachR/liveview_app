defmodule TriviumWeb.ContentLive.Show do
  use TriviumWeb, :live_view

  alias Trivium.Accounts
  alias Trivium.Classrooms
  alias Trivium.Multimedia
  alias Trivium.Exercises

  alias TriviumWeb.Presence
  alias Phoenix.Socket.Broadcast

  @impl true
  def mount(params, session, socket) do
    IO.puts "CONNECTED >>>>> #{inspect(connected?(socket))}"
    if user = session["user_token"] && Accounts.get_user_by_session_token(session["user_token"]) do

      concept_id = params["concept_id"]
      classroom_id = Classrooms.get_classroom_id_from_concept_id(concept_id)

      Phoenix.PubSub.subscribe(Trivium.PubSub, "concepts:#{concept_id}")
      Phoenix.PubSub.subscribe(Trivium.PubSub, "concepts:#{concept_id}" <> ":#{user.id}")
      {:ok, _} = Presence.track(self(), "concepts:#{concept_id}", user.id, %{email: user.email, name: user.name, avatar: user.avatar})

      socket =
        socket
          |> assign(:connected_users, [])
          |> assign(current_user: user)
          |> assign(:current_user_policy, Accounts.user_policy(user, classroom_id))
          |> assign(:user_answered_this_question, Exercises.list_answers_by_current_user(user))
          |> assign(concept_id: concept_id)
          |> assign(classroom_id: classroom_id)

      if user.role == "root" || user.role == "sales" do
        {:ok, socket}
      else
        if Accounts.access_policy_for(user, classroom_id) != [] do
          {:ok, socket}
        else
          {:ok,
            socket
            |> put_flash(:error, "You are not Authorized!")
            |> redirect(to: "/")
          }
        end
      end

    else
      {:ok, assign(socket, current_user: nil)}
    end
  end

  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    concept = Classrooms.get_concept!(socket.assigns.concept_id)
    content = Classrooms.get_content!(id)

    {:noreply,
     socket
     |> assign(:content, content)
     |> assign(:contents, Classrooms.all_contents_by_concept(concept))
     |> assign(:concept, concept)
     |> assign(:edit_mode, "presentation")
     |> assign(:contenteditable, false)
     |> assign(:urlform, "none")
     |> assign(:media_type, nil)
     |> assign(:uploadform, nil)
     |> assign(:videoform, nil)
     |> assign(:audioform, nil)
     |> assign(:frameform, nil)
   }
  end

  ########
  #
  #  PRESENCE
  #
  ########

  @impl true
  def handle_info(%Broadcast{event: "presence_diff", payload: _payload}, socket) do
    connected_users =
      Presence.list("concepts:#{socket.assigns.concept.id}")
      |> Enum.map(fn {_user_id, data} ->
        data[:metas]
        |> List.first()
      end)

    {:noreply, assign(socket, connected_users: connected_users)}
  end

  ########
  #
  #  ROLE AND POLICY
  #
  ########

  defp user_policy(user, classroom_id) do
    Accounts.user_policy(user, classroom_id)
  end

  defp authorized(socket) do
    user = socket.assigns.current_user
    classroom_id = socket.assigns.classroom_id

    if user_policy(user, classroom_id) == "teacher" or user.role == "root" do
      true
    else
      false
    end
  end

  defp can?(current_user, classroom_id) do
    user = current_user
    classroom_id = classroom_id

    if user_policy(user, classroom_id) == "teacher" or user.role == "root" do
      true
    else
      false
    end
  end


  ########
  #
  #  RESOURCES
  #
  ########

  @impl true
  def handle_info({:update_resource}, socket) do
    {:noreply, assign(socket, :content, Classrooms.get_content!(socket.assigns.content.id))}
  end

  ########
  #
  #  NEW CONTENT
  #
  ########

  @impl true
  def handle_event("new-content", _, socket) do
    contents = Classrooms.all_contents_by_concept(socket.assigns.concept)
    new_position = List.last(contents).position + 1

    if authorized(socket) do
      case Classrooms.create_content(%{name: "Add a title", position: new_position, concept_id: socket.assigns.concept.id}) do
        {:ok, content} ->
          {:noreply,
            socket
              |> put_flash(:info, "Content created successfully!")
              |> push_redirect(to: Routes.content_show_path(socket, :show, socket.assigns.concept.id, content))
              |> assign(:edit_mode, "editable")
              |> assign(:contenteditable, true)
          }

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, changeset: changeset)}
      end
    else
      socket =
        socket
        |> put_flash(:error, "You are not Authorized!")
        |> redirect(to: Routes.content_show_path(socket, :show, socket.assigns.concept.id, socket.assigns.content.id))

      {:noreply, socket}
    end
  end

  ########
  #
  #  CONTENT
  #
  ########

  @impl true
  def handle_event("update-content-name", %{"name" => name, "id" => id}, socket) do
    id = String.to_integer(id)

    content = Classrooms.get_content!(id)

    case Classrooms.update_content(content, %{name: name}) do
      {:ok, _content} ->
        {:noreply,
          socket
          |> assign(:content, Classrooms.get_content!(socket.assigns.content.id))
          |> assign(:contents, Classrooms.all_contents_by_concept(socket.assigns.concept))
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def handle_event("update-content-position", %{"position" => position, "id" => id}, socket) do
    id = String.to_integer(id)
    new_position = String.to_integer(position)

    content = Classrooms.get_content!(id)

    case Classrooms.update_content(content, %{position: new_position}) do
      {:ok, _content} ->
        {:noreply, assign(socket, :content, Classrooms.get_content!(socket.assigns.content.id))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def handle_event("delete-content", %{"id" => id}, socket) do
    content = Classrooms.get_content!(id)
    {:ok, _} = Classrooms.delete_content(content)

    contents = Classrooms.all_contents_by_concept(socket.assigns.concept)

    {:noreply,
      socket
      |> push_redirect(to: Routes.content_show_path(socket, :show, socket.assigns.concept.id, tail_contents(contents)))
    }
  end

  defp tail_contents(contents) do
    Classrooms.get_content!(List.last(contents).id)
  end

  ########
  #
  #  WRITING
  #
  ########

  @impl true
  def handle_event("new-writing", %{"content_id" => content_id}, socket) do
    content_id = String.to_integer(content_id)

    case Multimedia.create_writing(%{body: "Type here", content_id: content_id}) do
      {:ok, writing} ->
        {:noreply,
          socket
          |> assign(:content, Classrooms.get_content!(socket.assigns.content.id))
          |> assign(:edit_mode, "editable")
          |> assign(:contenteditable, true)
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def handle_event("update-writing", params, socket) do
    writing = Multimedia.get_writing!(params["id"])

    case Multimedia.update_writing(writing, params) do
      {:ok, _writing} ->
        {:noreply, assign(socket, :content, Classrooms.get_content!(socket.assigns.content.id))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp as_html(txt) do
    txt
    |> HtmlSanitizeEx.html5()
    |> raw
  end

  ########
  #
  #  URLFORM
  #
  ########

  @impl true
  def handle_event("show-urlform", %{"media_type" => media_type}, socket) do

    socket =
      socket
      |> assign(:urlform, "block")
      |> assign(:edit_mode, "presentation")
      |> assign(:media_type, media_type)

    {:noreply, socket}
  end

  @impl true
  def handle_event("cancel-formatic", _, socket) do
    socket =
      socket
      |> assign(:urlform, "none")

    {:noreply, socket}
  end

  @impl true
  def handle_event("new-internet-image", %{"url" => url}, socket) do
    content_id = socket.assigns.content.id

    case Multimedia.create_internet_image(%{url: url, legend: "Add a Legend to your image", content_id: content_id}) do
      {:ok, _internet_image} ->
        {:noreply,
          socket
          |> assign(:content, Classrooms.get_content!(content_id))
          |> assign(:urlform, "none")
          |> assign(:edit_mode, "editable")
          |> assign(:contenteditable, true)
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def handle_event("update-internet-image-legend", %{"legend" => legend, "id" => id}, socket) do
    id = String.to_integer(id)
    internet_image = Multimedia.get_internet_image!(id)

    case Multimedia.update_internet_image(internet_image, %{legend: legend}) do
      {:ok, _internet_image} ->
        {:noreply, assign(socket, :content, Classrooms.get_content!(socket.assigns.content.id))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  ########
  #
  #  YOUTUBE
  #
  ########

  @impl true
  def handle_event("new-youtube", %{"url" => url}, socket) do
    content_id = socket.assigns.content.id

    case Multimedia.create_youtube(%{url: url, legend: "Add a Legend to your video", content_id: content_id}) do
      {:ok, _youtube} ->
        {:noreply,
          socket
          |> assign(:content, Classrooms.get_content!(content_id))
          |> assign(:urlform, "none")
          |> assign(:edit_mode, "editable")
          |> assign(:contenteditable, true)
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def handle_event("update-youtube-legend", %{"legend" => legend, "id" => id}, socket) do
    id = String.to_integer(id)
    youtube = Multimedia.get_youtube!(id)

    case Multimedia.update_youtube(youtube, %{legend: legend}) do
      {:ok, _youtube} ->
        {:noreply, assign(socket, :content, Classrooms.get_content!(socket.assigns.content.id))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp player_id(video) do
    Regex.named_captures(~r{^.*(?:youtu\.be/|\w+/|v=)(?<id>[^#&?]*)}, video)
    |> get_in(["id"])
  end

  ########
  #
  #  IMAGE
  #
  ########

  @impl true
  def handle_event("show-image-form", %{"media_type" => media_type}, socket) do

    socket =
      socket
      |> assign(:uploadform, "block")
      |> assign(:edit_mode, "editable")
      |> assign(:media_type, media_type)

    {:noreply, socket}
  end

  @impl true
  def handle_event("cancel-uploadform", _, socket) do
    socket =
      socket
      |> assign(:uploadform, nil)
      |> assign(:edit_mode, "presentation")

    {:noreply, socket}
  end

  @impl true
  def handle_event("update-image-legend", %{"legend" => legend, "id" => id}, socket) do
    id = String.to_integer(id)
    image = Multimedia.get_image!(id)

    case Multimedia.update_image(image, %{legend: legend}) do
      {:ok, _image} ->
        {:noreply, assign(socket, :content, Classrooms.get_content!(socket.assigns.content.id))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def handle_info({:image_uploaded}, socket) do
    :timer.sleep 1500

    socket =
      socket
      |> push_redirect(to: Routes.content_show_path(socket, :show, socket.assigns.concept.id, socket.assigns.content.id))

    {:noreply, socket}
  end

  ########
  #
  #  VIDEO
  #
  ########

  @impl true
  def handle_event("show-video-form", %{"media_type" => media_type}, socket) do

    socket =
      socket
      |> assign(:videoform, "block")
      |> assign(:edit_mode, "editable")
      |> assign(:media_type, media_type)

    {:noreply, socket}
  end

  @impl true
  def handle_event("cancel-videoform", _, socket) do
    socket =
      socket
      |> assign(:videoform, nil)
      |> assign(:edit_mode, "presentation")

    {:noreply, socket}
  end

  @impl true
  def handle_event("update-video-legend", %{"legend" => legend, "id" => id}, socket) do
    id = String.to_integer(id)
    video = Multimedia.get_video!(id)

    case Multimedia.update_video(video, %{legend: legend}) do
      {:ok, video} ->
        {:noreply, assign(socket, :content, Classrooms.get_content!(video.content_id))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def handle_info({:video_uploaded}, socket) do
    :timer.sleep 2500

    socket =
      socket
      |> push_redirect(to: Routes.content_show_path(socket, :show, socket.assigns.concept.id, socket.assigns.content.id))

    {:noreply, socket}
  end

  ########
  #
  #  AUDIO
  #
  ########

  @impl true
  def handle_event("show-audio-form", %{"media_type" => media_type}, socket) do

    socket =
      socket
      |> assign(:audioform, "block")
      |> assign(:edit_mode, "editable")
      |> assign(:media_type, media_type)

    {:noreply, socket}
  end

  @impl true
  def handle_event("cancel-audioform", _, socket) do
    socket =
      socket
      |> assign(:audioform, nil)
      |> assign(:edit_mode, "presentation")

    {:noreply, socket}
  end

  @impl true
  def handle_event("update-audio-legend", %{"legend" => legend, "id" => id}, socket) do
    id = String.to_integer(id)
    audio = Multimedia.get_audio!(id)

    case Multimedia.update_audio(audio, %{legend: legend}) do
      {:ok, audio} ->
        {:noreply, assign(socket, :content, Classrooms.get_content!(audio.content_id))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def handle_info({:audio_uploaded}, socket) do
    :timer.sleep 1500

    socket =
      socket
      |> push_redirect(to: Routes.content_show_path(socket, :show, socket.assigns.concept.id, socket.assigns.content.id))

    {:noreply, socket}
  end

  ########
  #
  #  FRAME
  #
  ########

  @impl true
  def handle_event("show-frame-form", %{"media_type" => media_type}, socket) do
    socket =
      socket
      |> assign(:frameform, "block")
      |> assign(:edit_mode, "editable")
      |> assign(:media_type, media_type)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:close_frameform}, socket) do
    socket =
      socket
      |> assign(:frameform, nil)
      |> assign(:edit_mode, "presentation")

    {:noreply, socket}
  end

  ########
  #
  #  NEXT - MARK AS COMPLETED - UNMARK - CONTENT
  #
  ########

  @impl true
  def handle_event("student-completed-concept", %{"user" => user, "concept" => concept}, socket) do
    case Classrooms.create_progress(%{user_id: user, concept_id: concept, classroom_id: socket.assigns.classroom_id,
                                      status: "student-marked-as-completed"}) do
      {:ok, progress} ->
        {:noreply,
          socket
            |> put_flash(:info, (gettext "Well Done!"))
            |> push_redirect(to: "/")
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  @impl true
  def handle_event("student-incomplete-concept", %{"user" => user, "concept" => concept}, socket) do
    progress = Classrooms.get_progress_by!(user, concept)
    {:ok, _} = Classrooms.delete_progress(progress)

    {:noreply,
      socket
      |> push_redirect(to: Routes.content_show_path(socket, :show, socket.assigns.concept.id, socket.assigns.content.id))
    }
  end

  defp this_collection(collection) do
    collection
    |> Enum.count()
  end

  defp get_next_id(contents_by_concept, current_id) do
    contents_by_concept |> Enum.map(&(&1.id)) |> Enum.find_value(fn x -> if x > current_id, do: x end)
  end

  defp user_completed(user) do
    Accounts.user_progresses(user)
    |> Enum.map(&(&1.concept_id)) # get a list
  end

  ########
  #
  #  EDIT-MODE
  #
  ########

  @impl true
  def handle_event("editable-mode", _, socket) do
    socket =
      socket
      |> assign(:edit_mode, "editable")
      |> assign(:contenteditable, true)

    {:noreply, socket}
  end

  @impl true
  def handle_event("presentation-mode", _, socket) do
    socket =
      socket
      |> assign(:edit_mode, "presentation")
      |> assign(:contenteditable, false)

    {:noreply, socket}
  end

  ########
  #
  #  LIST MEDIAS
  #
  ########

  defp list_media(content) do
    content.writings ++ content.youtubes ++ content.images ++ content.audios ++ content.videos ++ content.frames ++ content.questions ++ content.internet_images
    |> Enum.sort_by(&(&1.inserted_at))
  end

  ########
  #
  #  QA / QUIZ
  #
  ########

  @impl true
  def handle_event("new-qa", _, socket) do
    text = (gettext "Type your question here")
    content_id = socket.assigns.content.id

    case Exercises.create_question(%{question_text: text, type: "question", content_id: content_id, position: 1, score: 0}) do
      {:ok, _question} ->
        {:noreply,
          socket
          |> assign(:content, Classrooms.get_content!(socket.assigns.content.id))
          |> assign(:edit_mode, "editable")
          |> assign(:contenteditable, true)
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def handle_event("new-quiz", _, socket) do
    text = (gettext "Type your question here")
    content_id = socket.assigns.content.id

    case Exercises.create_question(%{question_text: text, type: "quizzes", content_id: content_id, position: 1, score: 0}) do
      {:ok, _question} ->
        {:noreply,
          socket
          |> assign(:content, Classrooms.get_content!(socket.assigns.content.id))
          |> assign(:edit_mode, "editable")
          |> assign(:contenteditable, true)
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def handle_event("update-question-text", params, socket) do
    question = Exercises.get_question!(params["id"])

    case Exercises.update_question(question, params) do
      {:ok, _question} ->
        {:noreply, assign(socket, :content, Classrooms.get_content!(socket.assigns.content.id))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def handle_event("update-quiz-text", params, socket) do
    question = Exercises.get_quiz!(params["id"])

    case Exercises.update_quiz(question, params) do
      {:ok, _quiz} ->
        {:noreply, assign(socket, :content, Classrooms.get_content!(socket.assigns.content.id))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def handle_event("update-question-score", params, socket) do
    question = Exercises.get_question!(params["id"])

    case Exercises.update_question(question, params) do
      {:ok, _question} ->
        {:noreply, assign(socket, :content, Classrooms.get_content!(socket.assigns.content.id))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def handle_info(%{event: "student_answer", payload: student_answer}, socket) do
    user = Accounts.get_user!(socket.assigns.current_user.id)

    {:noreply,
      socket
        |> assign(:content, Classrooms.get_content!(socket.assigns.content.id))
        |> assign(:user_answered_this_question, Exercises.list_answers_by_current_user(socket.assigns.current_user))
    }
  end

  @impl true
  def handle_info(%{event: "answer_to_be_deleted", payload: answer}, socket) do
    {:noreply,
      socket
        |> assign(:content, Classrooms.get_content!(socket.assigns.content.id))
        |> assign(:user_answered_this_question, Exercises.list_answers_by_current_user(socket.assigns.current_user))
    }
  end

  @impl true
  def handle_info({:update_exercises}, socket) do
    {:noreply,
      socket
        |> assign(:content, Classrooms.get_content!(socket.assigns.content.id))
        |> assign(:user_answered_this_question, Exercises.list_answers_by_current_user(socket.assigns.current_user))
    }
  end

  ########
  #
  #  PRIVATE FUNCTIONS
  #
  ########

  defp position_to_string(position) do
    if position < 10 do
      position
      |> Integer.to_string
      "0#{position}"
    else
      position
    end
  end

end
