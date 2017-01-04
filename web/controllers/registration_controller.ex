defmodule MusicQuiz.RegistrationController do
  use MusicQuiz.Web, :controller
  alias MusicQuiz.{User, Registration, Repo}

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)
    case Registration.create(changeset, Repo) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user, :access)
        |> put_flash(:info, "Successfully signed up! Welcome.")
        |> redirect(to: "/")
      {:error, changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end
end
