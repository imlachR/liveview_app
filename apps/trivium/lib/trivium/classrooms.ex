defmodule Trivium.Classrooms do
  @moduledoc """
  The Classrooms context.
  """

  import Ecto.Query, warn: false
  alias Trivium.Repo

  alias Trivium.Classrooms.Institution
  alias Trivium.Classrooms.Classroom
  alias Trivium.Classrooms.Subscription
  alias Trivium.Classrooms.Subject
  alias Trivium.Classrooms.Lesson
  alias Trivium.Classrooms.Concept
  alias Trivium.Classrooms.Content
  alias Trivium.Classrooms.Progress

  alias Trivium.Exercises.Answer
  alias Trivium.Accounts.User

  @doc """
  Returns the list of institutions.

  ## Examples

      iex> list_institutions()
      [%Institution{}, ...]

  """
  def list_institutions do
    Repo.all(Institution)
  end

  @doc """
  Gets a single institution.

  Raises `Ecto.NoResultsError` if the Institution does not exist.

  ## Examples

      iex> get_institution!(123)
      %Institution{}

      iex> get_institution!(456)
      ** (Ecto.NoResultsError)

  """

  def get_institution!(id) do
    Institution
    |> Repo.get!(id)
    |> Repo.preload([classrooms: from(c in Classroom, order_by: [c.position, c.id])])
  end

  @doc """
  Creates a institution.

  ## Examples

      iex> create_institution(%{field: value})
      {:ok, %Institution{}}

      iex> create_institution(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_institution(attrs \\ %{}) do
    %Institution{}
    |> Institution.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a institution.

  ## Examples

      iex> update_institution(institution, %{field: new_value})
      {:ok, %Institution{}}

      iex> update_institution(institution, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_institution(%Institution{} = institution, attrs) do
    institution
    |> Institution.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a institution.

  ## Examples

      iex> delete_institution(institution)
      {:ok, %Institution{}}

      iex> delete_institution(institution)
      {:error, %Ecto.Changeset{}}

  """
  def delete_institution(%Institution{} = institution) do
    Repo.delete(institution)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking institution changes.

  ## Examples

      iex> change_institution(institution)
      %Ecto.Changeset{data: %Institution{}}

  """
  def change_institution(%Institution{} = institution, attrs \\ %{}) do
    Institution.changeset(institution, attrs)
  end


  @doc """
  Returns the list of classrooms.

  ## Examples

      iex> list_classrooms()
      [%Classroom{}, ...]

  """
  def list_classrooms do
    Repo.all(Classroom)
  end

  def search_by_handle(handle) do
    list_classrooms()
    |> Enum.filter(&(&1.handle == handle))
  end

  @doc """
  Gets a single classroom.

  Raises `Ecto.NoResultsError` if the Classroom does not exist.

  ## Examples

      iex> get_classroom!(123)
      %Classroom{}

      iex> get_classroom!(456)
      ** (Ecto.NoResultsError)

  """

  def get_classroom!(id) do
    Classroom
    |> Repo.get!(id)
    |> Repo.preload(subscriptions: :user)
    |> Repo.preload(:users)
    |> Repo.preload(:institution)
    |> Repo.preload([subjects: from(s in Subject, order_by: s.position)])
    |> Repo.preload(subjects: [lessons: :concepts])
  end

  def get_classroom_score(c_id) do
    Repo.all from c in Classroom,
      join: s in Subscription, on: c.id == s.classroom_id,
      join: u in User, on: s.user_id == u.id,
      join: a in Answer, on: u.id == a.user_id,
      where: not is_nil(a.score) and c.id == ^c_id,
      select: a.score
  end

  def get_student_total_score(user_id) do
    q = from a in Answer,
        where: a.user_id == ^user_id and not is_nil(a.score)

    Repo.all(q)
  end

  def get_student_score_by_classroom(user) do
    q = Ecto.assoc(user, [:classrooms])

    Repo.all(q)
  end

  def get_user_classrooms(user) do
    Repo.all Ecto.assoc(user, :classrooms)
    |> order_by([c], [asc: c.inserted_at])
  end

  def get_classroom_name_by(classroom_id) do
    Repo.one from classroom in Classroom,
    where: classroom.id == ^classroom_id
  end

  def get_classroom_id_from_concept_id(concept_id) do
    Repo.one from c in Concept,
      where: c.id == ^concept_id,
      join: l in Lesson, on: l.id == c.lesson_id,
      join: s in Subject, on: s.id == l.subject_id,
      select: s.classroom_id
  end


  def get_classroom_simple!(id) do
    Classroom
    |> Repo.get!(id)
  end

  def list_classroom_questions_scores(classroom) do
    q = Ecto.assoc(classroom, [:subjects, :lessons, :concepts, :contents, :questions])
    |> select([q], q.score)

    Repo.all(q)
  end

  @doc """
  Creates a classroom.

  ## Examples

      iex> create_classroom(%{field: value})
      {:ok, %Classroom{}}

      iex> create_classroom(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_classroom(attrs \\ %{}) do
    %Classroom{}
    |> Classroom.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a classroom.

  ## Examples

      iex> update_classroom(classroom, %{field: new_value})
      {:ok, %Classroom{}}

      iex> update_classroom(classroom, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_classroom(%Classroom{} = classroom, attrs) do
    classroom
    |> Classroom.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a classroom.

  ## Examples

      iex> delete_classroom(classroom)
      {:ok, %Classroom{}}

      iex> delete_classroom(classroom)
      {:error, %Ecto.Changeset{}}

  """
  def delete_classroom(%Classroom{} = classroom) do
    Repo.delete(classroom)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking classroom changes.

  ## Examples

      iex> change_classroom(classroom)
      %Ecto.Changeset{data: %Classroom{}}

  """
  def change_classroom(%Classroom{} = classroom, attrs \\ %{}) do
    Classroom.changeset(classroom, attrs)
  end


  # used in classroom show.ex
  def list_subjects_by_classroom(classroom) do
    Ecto.assoc(classroom, :subjects)
    |> Trivium.Repo.all([subjects: from(s in Subject, order_by: [desc: :inserted_at])])
  end

  def list_subjects_for_tasks(classroom_id) do
    q = from subject in Subject,
        join: lesson in Lesson, on: subject.id == lesson.subject_id,
        join: concept in Concept, on: lesson.id == concept.lesson_id,
        where: subject.classroom_id == ^classroom_id

    Repo.all(q)
    |> Enum.uniq()
  end

  def get_classroom_subjects(classroom) do
    Repo.all Ecto.assoc(classroom, :subjects)
    |> order_by([s], [asc: s.inserted_at])
  end

  def get_subject_from_concept(lesson_id) do
    q = from l in Lesson,
        join: s in Subject, on: s.id == l.subject_id,
        where: l.id == ^lesson_id,
        select: s.slug

    Repo.all(q)
  end

  @doc """
  Gets a single subject.

  Raises `Ecto.NoResultsError` if the Subject does not exist.

  ## Examples

      iex> get_subject!(123)
      %Subject{}

      iex> get_subject!(456)
      ** (Ecto.NoResultsError)

  """
  def get_subject!(id) do
    Subject
    |> Repo.get!(id)
    |> Repo.preload(classroom: :institution)
  end

  def get_subject_simple!(id) do
    Subject
    |> Repo.get!(id)
  end

  @doc """
  Creates a subject.

  ## Examples

      iex> create_subject(%{field: value})
      {:ok, %Subject{}}

      iex> create_subject(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_subject(attrs \\ %{}) do
    %Subject{}
    |> Subject.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a subject.

  ## Examples

      iex> update_subject(subject, %{field: new_value})
      {:ok, %Subject{}}

      iex> update_subject(subject, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_subject(%Subject{} = subject, attrs) do
    subject
    |> Subject.changeset(attrs)
    |> Repo.update()
  end


  @doc """
  Deletes a subject.

  ## Examples

      iex> delete_subject(subject)
      {:ok, %Subject{}}

      iex> delete_subject(subject)
      {:error, %Ecto.Changeset{}}

  """
  def delete_subject(%Subject{} = subject) do
    Repo.delete(subject)
    # |> notify_subscribers([:subject, :deleted])
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking subject changes.

  ## Examples

      iex> change_subject(subject)
      %Ecto.Changeset{data: %Subject{}}

  """
  def change_subject(%Subject{} = subject, attrs \\ %{}) do
    Subject.changeset(subject, attrs)
  end


  def list_lessons_by_subject(subject) do
    q = from l in Lesson,
        where: l.subject_id == ^subject.id,
        order_by: [asc: l.position, asc: l.inserted_at]

    Repo.all(q)
  end


  def get_lesson!(id) do
    Lesson
    |> Repo.get!(id)
    |> Repo.preload([concepts: from(c in Concept, order_by: c.inserted_at)])
    |> Repo.preload(subject: :classroom)
    |> Repo.preload(concepts: :contents)
  end

  @doc """
  Creates a lesson.

  ## Examples

      iex> create_lesson(%{field: value})
      {:ok, %Lesson{}}

      iex> create_lesson(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_lesson(attrs \\ %{}) do
    %Lesson{}
    |> Lesson.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a lesson.

  ## Examples

      iex> update_lesson(lesson, %{field: new_value})
      {:ok, %Lesson{}}

      iex> update_lesson(lesson, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_lesson(%Lesson{} = lesson, attrs) do
    lesson
    |> Lesson.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a lesson.

  ## Examples

      iex> delete_lesson(lesson)
      {:ok, %Lesson{}}

      iex> delete_lesson(lesson)
      {:error, %Ecto.Changeset{}}

  """
  def delete_lesson(%Lesson{} = lesson) do
    Repo.delete(lesson)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking lesson changes.

  ## Examples

      iex> change_lesson(lesson)
      %Ecto.Changeset{data: %Lesson{}}

  """
  def change_lesson(%Lesson{} = lesson, attrs \\ %{}) do
    Lesson.changeset(lesson, attrs)
  end


  # Is being used on activites user subscribed
  # def list_concepts_by(classroom_id, user_progresses) do
  #   q = from concept in Concept,
  #       join: lesson in Lesson, on: lesson.id == concept.lesson_id,
  #       join: subject in Subject, on: subject.id == lesson.subject_id,
  #       join: classroom in Classroom, on: classroom.id == subject.classroom_id,
  #       where: classroom.id == ^classroom_id,
  #       where: concept.id not in ^user_progresses
  #
  #   Repo.all(q)
  # end

  def list_concepts_by(classroom, user_progresses) do
    q = Ecto.assoc(classroom, [:subjects, :lessons, :concepts])
    |> where([c], c.id not in ^user_progresses)
    |> order_by(asc: :inserted_at)

    Repo.all(q)
  end

  def list_concepts_by_lesson(lesson) do
    q = from c in Concept,
        where: c.lesson_id == ^lesson.id,
        order_by: [asc: c.position, asc: c.inserted_at]

    Repo.all(q)
  end

  # Is being used on activites user subscribed
  def list_done_tasks_by_user_progress_and_classroom(user_id, classroom_id) do
    query = from c in Concept,
            join: p in Progress, on: c.id == p.concept_id,
            where: p.user_id == ^user_id,
            where: p.classroom_id == ^classroom_id,
            where: p.status == "student-marked-as-completed"

    Repo.all(query)
  end

  @doc """
  Gets a single concept.

  Raises `Ecto.NoResultsError` if the Concept does not exist.

  ## Examples

      iex> get_concept!(123)
      %Concept{}

      iex> get_concept!(456)
      ** (Ecto.NoResultsError)

  """

  def get_concept!(id) do
    Concept
    |> Repo.get!(id)
    |> Repo.preload([contents: from(c in Content, order_by: c.inserted_at, order_by: c.position)])
    |> Repo.preload(lesson: [subject: :classroom])
  end

  @doc """
  Creates a concept.

  ## Examples

      iex> create_concept(%{field: value})
      {:ok, %Concept{}}

      iex> create_concept(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_concept(attrs \\ %{}) do
    %Concept{}
    |> Concept.changeset(attrs)
    |> Repo.insert()
  end
#
  @doc """
  Updates a concept.

  ## Examples

      iex> update_concept(concept, %{field: new_value})
      {:ok, %Concept{}}

      iex> update_concept(concept, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_concept(%Concept{} = concept, attrs) do
    concept
    |> Concept.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a concept.

  ## Examples

      iex> delete_concept(concept)
      {:ok, %Concept{}}

      iex> delete_concept(concept)
      {:error, %Ecto.Changeset{}}

  """
  def delete_concept(%Concept{} = concept) do
    Repo.delete(concept)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking concept changes.

  ## Examples

      iex> change_concept(concept)
      %Ecto.Changeset{data: %Concept{}}

  """
  def change_concept(%Concept{} = concept, attrs \\ %{}) do
    Concept.changeset(concept, attrs)
  end


  @doc """
  Returns the list of contents.

  ## Examples

      iex> list_contents()
      [%Content{}, ...]

  """
  def list_contents do
    Repo.all(Content)
  end

  def all_contents_by_concept(concept) do
    Ecto.assoc(concept, :contents)
    |> order_by([c], [asc: c.id])
    |> Trivium.Repo.all()
  end


  @doc """
  Gets a single content.

  Raises `Ecto.NoResultsError` if the Content does not exist.

  ## Examples

      iex> get_content!(123)
      %Content{}

      iex> get_content!(456)
      ** (Ecto.NoResultsError)

  """

  def get_content!(id) do
    Content
    |> Repo.get!(id)
    |> Repo.preload(:concept)
    |> Repo.preload(:writings)
    |> Repo.preload(:images)
    |> Repo.preload(:internet_images)
    |> Repo.preload(:videos)
    |> Repo.preload(:youtubes)
    |> Repo.preload(:audios)
    |> Repo.preload(:frames)
    |> Repo.preload(questions: [answers: [user: :avatar]])
    |> Repo.preload(questions: :quizzes)
  end

  @doc """
  Creates a content.

  ## Examples

      iex> create_content(%{field: value})
      {:ok, %Content{}}

      iex> create_content(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_content(attrs \\ %{}) do
    %Content{}
    |> Content.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a content.

  ## Examples

      iex> update_content(content, %{field: new_value})
      {:ok, %Content{}}

      iex> update_content(content, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_content(%Content{} = content, attrs) do
    content
    |> Content.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a content.

  ## Examples

      iex> delete_content(content)
      {:ok, %Content{}}

      iex> delete_content(content)
      {:error, %Ecto.Changeset{}}

  """
  def delete_content(%Content{} = content) do
    Repo.delete(content)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking content changes.

  ## Examples

      iex> change_content(content)
      %Ecto.Changeset{data: %Content{}}

  """
  def change_content(%Content{} = content, attrs \\ %{}) do
    Content.changeset(content, attrs)
  end

  @doc """
  Returns the list of subscriptions.

  ## Examples

      iex> list_subscriptions()
      [%Subscription{}, ...]

  """
  def list_subscriptions do
    Repo.all(Subscription)
  end

  def list_subscriptions_by_classroom(classroom) do
    Ecto.assoc(classroom, :subscriptions)
    |> Trivium.Repo.all()
    |> Repo.preload(user: [answers: from(a in Answer, where: not is_nil(a.score))])
    |> Repo.preload(user: :avatar)
  end

  def list_subscriptions_by_classroom_admissions(classroom) do
    Ecto.assoc(classroom, :subscriptions)
    |> where([s], s.accepted == true)
    |> Repo.all()
    |> Repo.preload(user: [answers: from(a in Answer, where: not is_nil(a.score))])
    |> Repo.preload(user: :avatar)
  end

  def list_subscriptions_by_classroom_requests(classroom) do
    Ecto.assoc(classroom, :subscriptions)
    |> where([s], s.accepted == false)
    |> Repo.all()
    |> Repo.preload(user: :avatar)
  end

  def list_subscriptions_by(user) do
    Repo.all Ecto.assoc(user, :subscriptions)
    |> order_by([s], [asc: s.inserted_at])
  end

  def get_progress_by!(user_id, concept_id) do
    progress = Repo.one from progress in Progress,
    where: progress.user_id == ^user_id and progress.concept_id == ^concept_id,
    left_join: user in assoc(progress, :user),
    left_join: concept in assoc(progress, :concept),
    preload: [user: user, concept: concept]
  end

  # def get_teacher_score(collection) do
  #   Repo.all(collection)
  #   |> Repo.preload([user: from(u in User, where: u.role == "student")])
  #   |> Repo.preload(user: [answers: from(a in Answer, where: not is_nil(a.score))])
  # end

  # query = from s in Subscription, where: s.classroom_id == 3 and s.accepted == true
  # subscriptions = Repo.all(query)
  # users = Ecto.assoc(subscriptions, :user)

  @doc """
  Gets a single subscription.

  Raises `Ecto.NoResultsError` if the Subscription does not exist.

  ## Examples

      iex> get_subscription!(123)
      %Subscription{}

      iex> get_subscription!(456)
      ** (Ecto.NoResultsError)

  """
  def get_subscription!(id), do: Repo.get!(Subscription, id)

  @doc """
  Creates a subscription.

  ## Examples

      iex> create_subscription(%{field: value})
      {:ok, %Subscription{}}

      iex> create_subscription(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_subscription(attrs \\ %{}) do
    %Subscription{}
    |> Subscription.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a subscription.

  ## Examples

      iex> update_subscription(subscription, %{field: new_value})
      {:ok, %Subscription{}}

      iex> update_subscription(subscription, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_subscription(%Subscription{} = subscription, attrs) do
    subscription
    |> Subscription.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a subscription.

  ## Examples

      iex> delete_subscription(subscription)
      {:ok, %Subscription{}}

      iex> delete_subscription(subscription)
      {:error, %Ecto.Changeset{}}

  """
  def delete_subscription(%Subscription{} = subscription) do
    Repo.delete(subscription)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking subscription changes.

  ## Examples

      iex> change_subscription(subscription)
      %Ecto.Changeset{data: %Subscription{}}

  """
  def change_subscription(%Subscription{} = subscription, attrs \\ %{}) do
    Subscription.changeset(subscription, attrs)
  end


  @doc """
  Returns the list of progresses.

  ## Examples

      iex> list_progresses()
      [%Progress{}, ...]

  """
  def list_progresses do
    Repo.all(Progress)
  end

  @doc """
  Gets a single progress.

  Raises `Ecto.NoResultsError` if the Progress does not exist.

  ## Examples

      iex> get_progress!(123)
      %Progress{}

      iex> get_progress!(456)
      ** (Ecto.NoResultsError)

  """

  def get_progress!(id) do
    Progress
    |> Repo.get!(id)
  end

  def get_progress_by!(user_id, concept_id) do
    progress = Repo.one from progress in Progress,
    where: progress.user_id == ^user_id and progress.concept_id == ^concept_id,
    left_join: user in assoc(progress, :user),
    left_join: concept in assoc(progress, :concept),
    preload: [user: user, concept: concept]
  end

  @doc """
  Creates a progress.

  ## Examples

      iex> create_progress(%{field: value})
      {:ok, %Progress{}}

      iex> create_progress(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_progress(attrs \\ %{}) do
    %Progress{}
    |> Progress.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a progress.

  ## Examples

      iex> update_progress(progress, %{field: new_value})
      {:ok, %Progress{}}

      iex> update_progress(progress, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_progress(%Progress{} = progress, attrs) do
    progress
    |> Progress.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a progress.

  ## Examples

      iex> delete_progress(progress)
      {:ok, %Progress{}}

      iex> delete_progress(progress)
      {:error, %Ecto.Changeset{}}

  """
  def delete_progress(%Progress{} = progress) do
    Repo.delete(progress)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking progress changes.

  ## Examples

      iex> change_progress(progress)
      %Ecto.Changeset{data: %Progress{}}

  """
  def change_progress(%Progress{} = progress, attrs \\ %{}) do
    Progress.changeset(progress, attrs)
  end
end
