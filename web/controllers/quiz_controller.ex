defmodule MusicQuiz.QuizController do
  use MusicQuiz.Web, :controller
  alias MusicQuiz.Repo
  alias MusicQuiz.Quiz

  def index(conn, _params) do
    conn
    |> assign(:quizzes, Enum.chunk(Repo.all(Quiz), 3))
    |> render "index.html"
  end

  def show(conn, %{"id" => id}) do
    quiz = Repo.get(Quiz, id) |> Repo.preload(:questions)
    conn
    |> assign(:quiz, quiz)
    |> assign(:questions, Quiz.questions_for_use(quiz))
    |> render "show.html"
  end
end
