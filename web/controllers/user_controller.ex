defmodule MusicQuiz.UserController do
  use MusicQuiz.Web, :controller
  use Guardian.Phoenix.Controller
  alias MusicQuiz.User
  alias MusicQuiz.Repo

  def show(conn, %{"id" => id}, _user, _claims) do
    conn
    |> assign(:user, Repo.get(User, id))
    |> assign(:quizzes, User.quizzes(id))
    |> render("show.html")
  end
end
