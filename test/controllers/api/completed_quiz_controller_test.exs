defmodule MusicQuiz.Api.QuizControllerTest do
  use MusicQuiz.ConnCase
  import MusicQuiz.Factory

  test "posting a completed quiz returns JSON for that quiz" do
    user = insert(:user)
    completed_quiz_params = %{"completed_quiz" => %{name: "Indie Rock Quiz", correct: 20, possible: 25}}
    conn = post build_conn, "/api/users/#{user.id}/completed_quizzes", completed_quiz_params
  end

  # test ".show returns json with 'id', 'name', and 'questions'" do
    # conn = build_conn()
    # quiz = insert(:quiz)
    # conn = get conn, "/api/quizzes/#{quiz.id}"
    # assert json_response(conn, 200) == %{"id" => quiz.id, "name" => quiz.name,
                                          # "questions" => []}
  # end

  # test "questions has responses within the response" do
    # conn = build_conn()
    # quiz = insert(:quiz)
    # response = insert(:response)
    # answer = insert(:answer)
    # insert(:question, quizzes: [quiz], responses: [response], answer: answer)
    # conn = get conn, "/api/quizzes/#{quiz.id}"
    # assert json_response(conn, 200)["questions"] |> Enum.at(0) |> Map.get("responses")
  # end
end
