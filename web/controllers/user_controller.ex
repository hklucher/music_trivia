defmodule MusicQuiz.UserController do
  use MusicQuiz.Web, :controller
  alias MusicQuiz.User
  
  def show(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    conn
    |> assign(:user, user)
    |> render("show.html")
  end
end
