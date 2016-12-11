defmodule MusicQuiz.UserView do
  use MusicQuiz.Web, :view

  def render("show.json", %{user: user}) do
    Map.take(user, [:id, :email])   
  end
end
