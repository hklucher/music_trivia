defmodule MusicQuiz.QuizIndexTest do
  use Hound.Helpers
  use MusicQuiz.ConnCase

  import MusicQuiz.Factory

  hound_session

  test "has a site explanation" do
    navigate_to("/")
    assert page_source =~ "What is it?"
  end

  test "has a list of quizzes" do
    insert_multiple_quizzes(10)
    navigate_to("/")
    quizzes = find_all_elements(:class, "quiz_column")
    refute Enum.empty?(quizzes)
  end
end
