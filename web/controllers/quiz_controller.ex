defmodule MusicQuiz.QuizController do
  use MusicQuiz.Web, :controller
  alias MusicQuiz.Repo
  alias MusicQuiz.Genre

  def index(conn, %{"genre_id" => genre_id}) do
    # TODO: It makes sense to display quizzes on a genre show page. Move this?
    genre = Repo.get(Genre, genre_id) |> Repo.preload(:quizzes)
    conn
    |> assign(:genre, genre)
    |> assign(:quizzes, genre.quizzes)
    |> render "index.html"
  end
end
