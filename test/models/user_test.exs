defmodule MusicQuiz.UserTest do
  use MusicQuiz.ModelCase
  import MusicQuiz.Factory
  alias MusicQuiz.User

  test ".quizzes/1 returns a list of completed quizzes for the user by id" do
    user = insert(:user)
    completed_quiz = insert(:completed_quiz, user: user)
    quizzes = User.quizzes(user.id) |> Enum.map(&(&1.id))
    assert Enum.member?(quizzes, completed_quiz.id)
  end

  test ".join_date/1 parses the users date as a string" do
    user = insert(:user)
    assert is_binary(User.join_date(user.id))
  end

  test "is not valid with an invalid email address" do
    attrs = %{email: "invalid@", password: "password"}
    changeset = User.changeset(%User{}, attrs)
    refute changeset.valid?
  end

  test "it is valid with a correctly formatted email address" do
    attrs = %{email: "email@email.com", password: "password"}
    changeset = User.changeset(%User{}, attrs)
    assert changeset.valid?
  end
end
