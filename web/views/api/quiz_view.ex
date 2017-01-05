require IEx
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
    prepared_responses = prepare_responses(question.responses)
    prepared_answer = prepare_answer(question.answer)
    Enum.shuffle(prepared_responses ++ [prepared_answer])
  end

  defp prepare_responses(responses) do
    Enum.map(responses, fn(response) ->
      response |> Map.take([:id, :content]) |> Map.put(:correct, false)
    end)
  end

  defp prepare_answer(answer) do
    answer |> Map.take([:id, :content]) |> Map.put(:correct, true)
  end

  defp answer_json(answer) do
    Map.take(answer, [:id, :content])
  end
end
