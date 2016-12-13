require IEx
defmodule MusicQuiz.Api.CompletedQuizView do
  use MusicQuiz.Web, :view

  def render("show.json", %{completed_quiz: completed_quiz}) do
    Map.take(completed_quiz, [:name, :possible, :correct])
  end

  def render("show.json", %{error: errors}) do
    error_list = Enum.map(errors, fn{field, explanation} -> %{field => elem(explanation, 0)} end)
    %{"errors" => error_list}
  end
end
