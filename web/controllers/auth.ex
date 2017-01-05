defmodule MusicQuiz.Auth do
  @moduledoc """
  Module to authenticate and log in a user using Guardian.
  """
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  def login(conn, user) do
    conn |> Guardian.Plug.sign_in(user, :access)
  end

  def login_by_email_and_pass(conn, email, given_pass, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(MusicQuiz.User, email: email)

    cond do
      user && checkpw(given_pass, user.crypted_password) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw
        {:error, :not_found, conn}
    end
  end
end
