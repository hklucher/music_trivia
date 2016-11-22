defmodule MusicQuiz.QuizTest do
  use MusicQuiz.ModelCase
  alias MusicQuiz.Quiz
  import MusicQuiz.Factory

  @valid_attrs %{name: "classic rock quiz", genre_id: 1}
  @invalid_attrs %{}

  test "changest with valid attributes" do
    changeset = Quiz.changeset(%Quiz{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changest = Quiz.changeset(%Quiz{}, @invalid_attrs)
    refute changest.valid?
  end

  test ".have_questions returns a list of quizzes that have at least one question" do
    question = insert(:question, content: "what year did the album 'in utero' release?")
    quiz_with_question = insert(:quiz, questions: [question])
    insert(:quiz, name: "Classic Rock Quiz")
    assert Quiz.have_questions == [quiz_with_question]
  end

  test ".have_questions does not include a quiz with no questions" do
    insert(:quiz)
    assert Quiz.have_questions == []
  end
end
