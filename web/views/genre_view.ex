defmodule MusicQuiz.GenreView do
  use MusicQuiz.Web, :view

  def titleize(genre) do
    genre
    |> String.split(" ")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end
end
