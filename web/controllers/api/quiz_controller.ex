defmodule MusicQuiz.Api.QuizController do
  use MusicQuiz.Web, :controller
  alias MusicQuiz.Repo
  alias MusicQuiz.Quiz

  def show(conn, %{"id" => id}) do
    quiz = Quiz |> Repo.get(id) |> Repo.preload(:questions)
    questions = quiz |> Quiz.questions_for_use |> Repo.preload([:responses, :answer])
    render conn, "show.json", %{quiz: quiz, questions: questions}
  end
end
