defmodule MusicQuiz.Api.QuizController do
  use MusicQuiz.Web, :controller
  alias MusicQuiz.Repo
  alias MusicQuiz.Quiz

  def show(conn, %{"id" => id}) do
    quiz = Repo.get(Quiz, id) |> Repo.preload(:questions)
    questions = Quiz.questions_for_use(quiz) |> Repo.preload([:responses, :answer])
    render conn, "show.json", %{quiz: quiz, questions: questions}
  end
end
