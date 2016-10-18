defmodule MusicQuiz.PageController do
  use MusicQuiz.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
