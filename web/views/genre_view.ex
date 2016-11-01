defmodule MusicQuiz.GenreView do
  use MusicQuiz.Web, :view

  def titleize(genre) do
    String.split(genre, " ")
    |> Enum.map(fn(x) -> String.capitalize(x) end)
    |> Enum.join(" ")
  end
end
