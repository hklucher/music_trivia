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

  def update(conn, %{"user" => user_params, "id" => user_id}, _user, _claims) do
    user = Repo.get(User, user_id)
    changeset = User.changeset(:update, user, user_params)
    case Repo.update(changeset) do
      {:ok, user_struct} ->
        conn
        |> assign(:user, user)
        |> assign(:quizzes, User.quizzes(user_id))
        |> put_flash(:success, "Updated your info")
        |> redirect(to: "/users/#{user_id}")
      {:error, user_struct} ->
        conn
        |> put_flash(:error, "An error occurred")
        |> assign(:user, user)
        |> assign(:quizzes, User.quizzes(user_id))
        |> render("show.html")
    end
  end
end
