defmodule MusicQuiz.Api.QuizView do
  use MusicQuiz.Web, :view

  def titleize(quiz_name) do
    String.split(quiz_name, " ")
    |> Enum.map(fn(x) -> String.capitalize(x) end)
    |> Enum.join(" ")
  end

  def render("show.json", %{quiz: quiz, questions: questions}) do
    quiz_json(quiz, questions)
  end

  def quiz_json(quiz, questions) do
    %{
      id: quiz.id,
      name: titleize(quiz.name),
      questions: questions_json(questions)
    }
  end

  defp questions_json(questions) do
    Enum.map(questions, fn(question) ->
      Map.take(question, [:id, :content, :answer_id])
      |> Map.put(:responses, responses_json(question))
      |> Map.put(:answer, answer_json(question.answer))
    end)
  end

  defp responses_json(question) do
    # Enum.map(responses, fn(response) -> Map.take(response, [:id, :content]) end)
    Enum.map(question.responses, fn(response) ->
      Map.take(response, [:id, :content])
    end)
  end

  defp answer_json(answer) do
    Map.take(answer, [:id, :content])
  end
end
