defmodule MusicQuiz.Api.QuizController do
  use MusicQuiz.Web, :controller
  alias MusicQuiz.Repo
  alias MusicQuiz.Quiz

  def show(conn, %{"id" => id}) do
    quiz = Repo.get(Quiz, id) |> Repo.preload(:questions)
    questions = quiz.questions |> Repo.preload(:responses)
    render conn, "show.json", %{quiz: quiz, questions: questions}
  end
end
