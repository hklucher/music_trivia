defmodule MusicQuiz.QuizController do
  use MusicQuiz.Web, :controller
  alias MusicQuiz.Repo
  alias MusicQuiz.Quiz

  # TODO: A quiz will end up having a LOT of questions, limit questions to 20 or so.
  def show(conn, %{"id" => id}) do
    quiz = Repo.get(Quiz, id) |> Repo.preload(:questions)
    conn
    |> assign(:quiz, quiz)
    |> assign(:questions, Quiz.questions_for_use(quiz))
    |> render "show.html"
  end
end
