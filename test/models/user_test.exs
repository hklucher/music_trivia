defmodule MusicQuiz.UserTest do
  use MusicQuiz.ModelCase
  import MusicQuiz.Factory
  alias MusicQuiz.User

  test "quizzes/1 returns a list of completed quizzes for the user by id" do
    user = insert(:user)
    completed_quiz = insert(:completed_quiz, user: user)
    quizzes = User.quizzes(user.id) |> Enum.map(&(&1.id))
    assert Enum.member?(quizzes, completed_quiz.id)
  end
end
