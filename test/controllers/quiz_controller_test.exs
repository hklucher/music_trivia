defmodule MusicQuiz.QuizControllerTest do
  use MusicQuiz.ConnCase
  import MusicQuiz.Factory

  test "gets show for a quiz" do
    quiz = insert(:quiz)
    response = build_conn(:get, "quizzes/#{quiz.id}") |> send_request
    assert response.status == 200
  end

  defp send_request(conn) do
    conn
    |> put_private(:plug_skip_csrf_protection, true)
    |> MusicQuiz.Endpoint.call([])
  end
end
