defmodule MusicQuiz.RegistrationController do
  use MusicQuiz.Web, :controller
  alias MusicQuiz.User

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, changeset: changeset)
  end
end
