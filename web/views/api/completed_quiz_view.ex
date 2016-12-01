require IEx
defmodule MusicQuiz.Api.CompletedQuizView do
  use MusicQuiz.Web, :view

  def render("create.json", %{"error" => message}) do
    %{"error" => "something went wrong"}
  end

  def render("create.json", %{completed_quiz: quiz}) do
    %{id: quiz.id, name: quiz.name, score: quiz.score, total_questions: quiz.total_questions}
  end
end
