defmodule MusicQuiz.Api.QuizControllerTest do
  use MusicQuiz.ConnCase
  import MusicQuiz.Factory

  test ".show returns json with 'id', 'name', and 'questions'" do
    conn = build_conn()
    quiz = insert(:quiz)
    conn = get conn, "/api/quizzes/#{quiz.id}"
    assert json_response(conn, 200) == %{"id" => quiz.id, "name" => quiz.name,
                                          "questions" => []}
  end

  test "questions has responses within the response" do
    conn = build_conn()
    quiz = insert(:quiz)
    response = insert(:response)
    answer = insert(:answer)
    insert(:question, quizzes: [quiz], responses: [response], answer: answer)
    conn = get conn, "/api/quizzes/#{quiz.id}"
    assert json_response(conn, 200)["questions"] |> Enum.at(0) |> Map.get("responses")
  end
end
