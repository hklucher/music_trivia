defmodule MusicQuiz.UserController do
  use MusicQuiz.Web, :controller
  use Guardian.Phoenix.Controller
  alias MusicQuiz.User

  def show(conn, %{"id" => id}, _user, _claims) do
    conn
    |> assign(:user, Repo.get(User, id))
    |> render("show.html")
  end
end
