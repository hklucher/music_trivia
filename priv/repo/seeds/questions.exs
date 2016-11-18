defmodule MusicQuiz.Seeds.Questions do
  alias MusicQuiz.{Repo, Genre, Quiz}

  def seed("album_authors") do
    Enum.each(Repo.all(Quiz), fn(quiz) ->
      genre = quiz_genre(quiz)
      albums = albums_by_genre(genre)
    end)
  end

  defp quiz_genre(quiz), do: (quiz |> Repo.preload(:genre)).genre
end
