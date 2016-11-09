defmodule MusicQuiz.Api.QuizView do
  use MusicQuiz.Web, :view

  def titleize(quiz_name) do
    String.split(quiz_name, " ")
    |> Enum.map(fn(x) -> String.capitalize(x) end)
    |> Enum.join(" ")
  end

  def render("show.json", %{quiz: quiz}) do
    quiz_json(quiz)
  end

  def quiz_json(quiz) do
    %{
      id: quiz.id,
      name: titleize(quiz.name),
      questions: Enum.map(quiz.questions, fn(q) -> %{id: q.id, content: q.content} end)
    }
  end
end
