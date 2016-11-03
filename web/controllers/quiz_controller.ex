defmodule MusicQuiz.QuizController do
  use MusicQuiz.Web, :controller
  alias MusicQuiz.Repo
  alias MusicQuiz.Quiz

  def show(conn, %{"id" => id}) do
    quiz = Repo.get(Quiz, id) |> Repo.preload(:questions)
    conn
    |> assign(:quiz, quiz)
    |> assign(:questions, Repo.preload(quiz.questions, [:answer, :responses]))
    |> render "show.html"
  end
end
