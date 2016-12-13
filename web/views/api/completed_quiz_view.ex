require IEx
defmodule MusicQuiz.Api.CompletedQuizView do
  use MusicQuiz.Web, :view

  def render("show.json", %{completed_quiz: completed_quiz}) do
    IEx.pry
    completed_quiz
  end

  def render("show.json", %{error: error}) do
    error
  end
end
