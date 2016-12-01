defmodule MusicQuiz.Api.QuizView do
  use MusicQuiz.Web, :view

  def render("create.json", %{"error" => message}) do
    %{"error" => "something went wrong"}
  end

  def render("create.json", changeset) do
    changeset
  end
end
