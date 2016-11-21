defmodule MusicQuiz.QuizView do
  use MusicQuiz.Web, :view
  alias MusicQuiz.Repo
  alias MusicQuiz.Genre

  def titleize(quiz_name) do
    String.split(quiz_name, " ")
    |> Enum.map(fn(x) -> String.capitalize(x) end)
    |> Enum.join(" ")
  end

  def preview_image(quiz) do
    genre = Repo.preload(quiz, :genre).genre
    (Genre.albums(genre) |> Enum.at(0)).image_url
  end
end
