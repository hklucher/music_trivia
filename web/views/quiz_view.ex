defmodule MusicQuiz.QuizView do
  use MusicQuiz.Web, :view

  alias MusicQuiz.Repo
  alias MusicQuiz.Genre

  def titleize(quiz_name) do
    quiz_name
    |> String.split(" ")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end
end
