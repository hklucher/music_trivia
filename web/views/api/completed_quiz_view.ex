defmodule MusicQuiz.Api.CompletedQuizView do
  use MusicQuiz.Web, :view

  def render("show.json", %{completed_quiz: completed_quiz}) do
    Map.take(completed_quiz, [:possible, :correct])
  end

  def render("show.json", %{error: error}) do
    error
  end
end
