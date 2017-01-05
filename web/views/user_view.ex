defmodule MusicQuiz.UserView do
  use MusicQuiz.Web, :view

  alias MusicQuiz.Repo
  alias MusicQuiz.User
  alias MusicQuiz.Endpoint

  def render("show.json", %{user: user}) do
    Map.take(user, [:id, :email])
  end

  def display_name(%User{first_name:  first_name, last_name: last_name}) do
    "#{first_name} #{last_name}"
  end

  def display_name(%User{email: email}), do: email
end
