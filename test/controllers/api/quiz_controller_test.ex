defmodule MusicQuiz.Api.QuizControllerTest do
  use MusicQuiz.ConnCase

  test "#show renders a quiz" do
    conn = build_conn()
    quiz = insert(:quiz)

    conn = get conn, "/api/quizzes/#{quiz.id}"

    assert json_response(conn, 200) == %{"id" => quiz.id, "name" => quiz.name}
  end
end
