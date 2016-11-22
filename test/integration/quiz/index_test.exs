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

  test "clicking a quiz link sends the user to that quizzes show page" do
    insert_multiple_quizzes(10)
    navigate_to("/")
    link_container = find_element(:class, "quiz_column")
    link = find_within_element(link_container, :tag, "a")
    click(link)
    assert page_source =~ "Quiz"
  end
end
