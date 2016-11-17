defmodule MusicQuiz.GenreController do
  use MusicQuiz.Web, :controller
  alias MusicQuiz.Repo
  alias MusicQuiz.Genre

  def index(conn, _params) do
    conn
    |> assign(:genres, Enum.chunk(Repo.all(Genre), 2))
    |> render "index.html"
  end

  def show(conn, %{"id" => id}) do
    genre_id = String.to_integer(id)
    conn
    |> assign(:genre, Repo.get(Genre, id))
    |> assign(:quizzes, Repo.all(from q in "quizzes", select: {q.id, q.name}, where: q.genre_id == ^genre_id))
    |> render "show.html"
  end
end
