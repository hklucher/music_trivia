defmodule MusicQuiz.ArtistController do
  use MusicQuiz.Web, :controller
  alias MusicQuiz.Repo
  alias MusicQuiz.Artist

  def index(conn, _params) do
    conn
    |> assign(:artists, Repo.all(from a in Artist, limit: 10))
    |> render("index.html")
  end
end
