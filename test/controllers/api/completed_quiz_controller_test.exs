defmodule MusicQuiz.Api.QuizControllerTest do
  use MusicQuiz.ConnCase
  import MusicQuiz.Factory

  test "posting a completed quiz returns JSON for that quiz" do
    user = insert(:user)
    completed_quiz_params = %{"completed_quiz" => %{name: "Indie Rock Quiz", correct: 20, possible: 25}}
    conn = post build_conn, "/api/users/#{user.id}/completed_quizzes", completed_quiz_params
    assert json_response(conn, 200)
  end

  test "posting an invalid quiz returns JSON for the errors" do
    user = insert(:user)
    completed_quiz_params = %{"completed_quiz" => %{name: "", correct: nil, possible: nil}}
    conn = post build_conn, "/api/users/#{user.id}/completed_quizzes", completed_quiz_params
    assert json_response(conn, 200)["errors"]
  end
end
