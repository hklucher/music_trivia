defmodule MusicQuiz.QuizController do
  use MusicQuiz.Web, :controller
  alias MusicQuiz.Repo
  alias MusicQuiz.Quiz

  def show(conn, %{"id" => id}) do
    conn
    |> assign(:quiz, Repo.get(Quiz, id))
    |> render "show.html"
  end
end
