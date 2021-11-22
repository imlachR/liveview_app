defmodule Trivium.ExercisesTest do
  use Trivium.DataCase

  alias Trivium.Exercises

  describe "qas" do
    alias Trivium.Exercises.Qa

    @valid_attrs %{question: "some question"}
    @update_attrs %{question: "some updated question"}
    @invalid_attrs %{question: nil}

    def qa_fixture(attrs \\ %{}) do
      {:ok, qa} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Exercises.create_qa()

      qa
    end

    test "list_qas/0 returns all qas" do
      qa = qa_fixture()
      assert Exercises.list_qas() == [qa]
    end

    test "get_qa!/1 returns the qa with given id" do
      qa = qa_fixture()
      assert Exercises.get_qa!(qa.id) == qa
    end

    test "create_qa/1 with valid data creates a qa" do
      assert {:ok, %Qa{} = qa} = Exercises.create_qa(@valid_attrs)
      assert qa.question == "some question"
    end

    test "create_qa/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Exercises.create_qa(@invalid_attrs)
    end

    test "update_qa/2 with valid data updates the qa" do
      qa = qa_fixture()
      assert {:ok, %Qa{} = qa} = Exercises.update_qa(qa, @update_attrs)
      assert qa.question == "some updated question"
    end

    test "update_qa/2 with invalid data returns error changeset" do
      qa = qa_fixture()
      assert {:error, %Ecto.Changeset{}} = Exercises.update_qa(qa, @invalid_attrs)
      assert qa == Exercises.get_qa!(qa.id)
    end

    test "delete_qa/1 deletes the qa" do
      qa = qa_fixture()
      assert {:ok, %Qa{}} = Exercises.delete_qa(qa)
      assert_raise Ecto.NoResultsError, fn -> Exercises.get_qa!(qa.id) end
    end

    test "change_qa/1 returns a qa changeset" do
      qa = qa_fixture()
      assert %Ecto.Changeset{} = Exercises.change_qa(qa)
    end
  end

  describe "answers" do
    alias Trivium.Exercises.Answer

    @valid_attrs %{answer: "some answer"}
    @update_attrs %{answer: "some updated answer"}
    @invalid_attrs %{answer: nil}

    def answer_fixture(attrs \\ %{}) do
      {:ok, answer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Exercises.create_answer()

      answer
    end

    test "list_answers/0 returns all answers" do
      answer = answer_fixture()
      assert Exercises.list_answers() == [answer]
    end

    test "get_answer!/1 returns the answer with given id" do
      answer = answer_fixture()
      assert Exercises.get_answer!(answer.id) == answer
    end

    test "create_answer/1 with valid data creates a answer" do
      assert {:ok, %Answer{} = answer} = Exercises.create_answer(@valid_attrs)
      assert answer.answer == "some answer"
    end

    test "create_answer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Exercises.create_answer(@invalid_attrs)
    end

    test "update_answer/2 with valid data updates the answer" do
      answer = answer_fixture()
      assert {:ok, %Answer{} = answer} = Exercises.update_answer(answer, @update_attrs)
      assert answer.answer == "some updated answer"
    end

    test "update_answer/2 with invalid data returns error changeset" do
      answer = answer_fixture()
      assert {:error, %Ecto.Changeset{}} = Exercises.update_answer(answer, @invalid_attrs)
      assert answer == Exercises.get_answer!(answer.id)
    end

    test "delete_answer/1 deletes the answer" do
      answer = answer_fixture()
      assert {:ok, %Answer{}} = Exercises.delete_answer(answer)
      assert_raise Ecto.NoResultsError, fn -> Exercises.get_answer!(answer.id) end
    end

    test "change_answer/1 returns a answer changeset" do
      answer = answer_fixture()
      assert %Ecto.Changeset{} = Exercises.change_answer(answer)
    end
  end

  describe "questions" do
    alias Trivium.Exercises.Question

    @valid_attrs %{question_text: "some question_text"}
    @update_attrs %{question_text: "some updated question_text"}
    @invalid_attrs %{question_text: nil}

    def question_fixture(attrs \\ %{}) do
      {:ok, question} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Exercises.create_question()

      question
    end

    test "list_questions/0 returns all questions" do
      question = question_fixture()
      assert Exercises.list_questions() == [question]
    end

    test "get_question!/1 returns the question with given id" do
      question = question_fixture()
      assert Exercises.get_question!(question.id) == question
    end

    test "create_question/1 with valid data creates a question" do
      assert {:ok, %Question{} = question} = Exercises.create_question(@valid_attrs)
      assert question.question_text == "some question_text"
    end

    test "create_question/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Exercises.create_question(@invalid_attrs)
    end

    test "update_question/2 with valid data updates the question" do
      question = question_fixture()
      assert {:ok, %Question{} = question} = Exercises.update_question(question, @update_attrs)
      assert question.question_text == "some updated question_text"
    end

    test "update_question/2 with invalid data returns error changeset" do
      question = question_fixture()
      assert {:error, %Ecto.Changeset{}} = Exercises.update_question(question, @invalid_attrs)
      assert question == Exercises.get_question!(question.id)
    end

    test "delete_question/1 deletes the question" do
      question = question_fixture()
      assert {:ok, %Question{}} = Exercises.delete_question(question)
      assert_raise Ecto.NoResultsError, fn -> Exercises.get_question!(question.id) end
    end

    test "change_question/1 returns a question changeset" do
      question = question_fixture()
      assert %Ecto.Changeset{} = Exercises.change_question(question)
    end
  end

  describe "answers" do
    alias Trivium.Exercises.Answer

    @valid_attrs %{answer_text: "some answer_text"}
    @update_attrs %{answer_text: "some updated answer_text"}
    @invalid_attrs %{answer_text: nil}

    def answer_fixture(attrs \\ %{}) do
      {:ok, answer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Exercises.create_answer()

      answer
    end

    test "list_answers/0 returns all answers" do
      answer = answer_fixture()
      assert Exercises.list_answers() == [answer]
    end

    test "get_answer!/1 returns the answer with given id" do
      answer = answer_fixture()
      assert Exercises.get_answer!(answer.id) == answer
    end

    test "create_answer/1 with valid data creates a answer" do
      assert {:ok, %Answer{} = answer} = Exercises.create_answer(@valid_attrs)
      assert answer.answer_text == "some answer_text"
    end

    test "create_answer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Exercises.create_answer(@invalid_attrs)
    end

    test "update_answer/2 with valid data updates the answer" do
      answer = answer_fixture()
      assert {:ok, %Answer{} = answer} = Exercises.update_answer(answer, @update_attrs)
      assert answer.answer_text == "some updated answer_text"
    end

    test "update_answer/2 with invalid data returns error changeset" do
      answer = answer_fixture()
      assert {:error, %Ecto.Changeset{}} = Exercises.update_answer(answer, @invalid_attrs)
      assert answer == Exercises.get_answer!(answer.id)
    end

    test "delete_answer/1 deletes the answer" do
      answer = answer_fixture()
      assert {:ok, %Answer{}} = Exercises.delete_answer(answer)
      assert_raise Ecto.NoResultsError, fn -> Exercises.get_answer!(answer.id) end
    end

    test "change_answer/1 returns a answer changeset" do
      answer = answer_fixture()
      assert %Ecto.Changeset{} = Exercises.change_answer(answer)
    end
  end

  describe "quizzes" do
    alias Trivium.Exercises.Quiz

    @valid_attrs %{quiz_text: "some quiz_text"}
    @update_attrs %{quiz_text: "some updated quiz_text"}
    @invalid_attrs %{quiz_text: nil}

    def quiz_fixture(attrs \\ %{}) do
      {:ok, quiz} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Exercises.create_quiz()

      quiz
    end

    test "list_quizzes/0 returns all quizzes" do
      quiz = quiz_fixture()
      assert Exercises.list_quizzes() == [quiz]
    end

    test "get_quiz!/1 returns the quiz with given id" do
      quiz = quiz_fixture()
      assert Exercises.get_quiz!(quiz.id) == quiz
    end

    test "create_quiz/1 with valid data creates a quiz" do
      assert {:ok, %Quiz{} = quiz} = Exercises.create_quiz(@valid_attrs)
      assert quiz.quiz_text == "some quiz_text"
    end

    test "create_quiz/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Exercises.create_quiz(@invalid_attrs)
    end

    test "update_quiz/2 with valid data updates the quiz" do
      quiz = quiz_fixture()
      assert {:ok, %Quiz{} = quiz} = Exercises.update_quiz(quiz, @update_attrs)
      assert quiz.quiz_text == "some updated quiz_text"
    end

    test "update_quiz/2 with invalid data returns error changeset" do
      quiz = quiz_fixture()
      assert {:error, %Ecto.Changeset{}} = Exercises.update_quiz(quiz, @invalid_attrs)
      assert quiz == Exercises.get_quiz!(quiz.id)
    end

    test "delete_quiz/1 deletes the quiz" do
      quiz = quiz_fixture()
      assert {:ok, %Quiz{}} = Exercises.delete_quiz(quiz)
      assert_raise Ecto.NoResultsError, fn -> Exercises.get_quiz!(quiz.id) end
    end

    test "change_quiz/1 returns a quiz changeset" do
      quiz = quiz_fixture()
      assert %Ecto.Changeset{} = Exercises.change_quiz(quiz)
    end
  end

  describe "scores" do
    alias Trivium.Exercises.Score

    @valid_attrs %{points: 42}
    @update_attrs %{points: 43}
    @invalid_attrs %{points: nil}

    def score_fixture(attrs \\ %{}) do
      {:ok, score} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Exercises.create_score()

      score
    end

    test "list_scores/0 returns all scores" do
      score = score_fixture()
      assert Exercises.list_scores() == [score]
    end

    test "get_score!/1 returns the score with given id" do
      score = score_fixture()
      assert Exercises.get_score!(score.id) == score
    end

    test "create_score/1 with valid data creates a score" do
      assert {:ok, %Score{} = score} = Exercises.create_score(@valid_attrs)
      assert score.points == 42
    end

    test "create_score/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Exercises.create_score(@invalid_attrs)
    end

    test "update_score/2 with valid data updates the score" do
      score = score_fixture()
      assert {:ok, %Score{} = score} = Exercises.update_score(score, @update_attrs)
      assert score.points == 43
    end

    test "update_score/2 with invalid data returns error changeset" do
      score = score_fixture()
      assert {:error, %Ecto.Changeset{}} = Exercises.update_score(score, @invalid_attrs)
      assert score == Exercises.get_score!(score.id)
    end

    test "delete_score/1 deletes the score" do
      score = score_fixture()
      assert {:ok, %Score{}} = Exercises.delete_score(score)
      assert_raise Ecto.NoResultsError, fn -> Exercises.get_score!(score.id) end
    end

    test "change_score/1 returns a score changeset" do
      score = score_fixture()
      assert %Ecto.Changeset{} = Exercises.change_score(score)
    end
  end
end
