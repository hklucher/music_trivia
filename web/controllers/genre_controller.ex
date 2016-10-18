defmodule MusicQuiz.GenreController do
  use MusicQuiz.Web, :controller
  alias MusicQuiz.Repo
  alias MusicQuiz.Genre

  def index(conn, _params) do
    conn
    |> assign(:genres, Repo.all(from g in Genre, select: g))
    |> render "index.html"
  end

  def show(conn, %{"id" => id}) do
    conn
    |> assign(:genre, Repo.get(Genre, id))
    |> render "show.html"
  end
end
