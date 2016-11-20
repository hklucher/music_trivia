defmodule MusicQuiz.Seeds.Questions do
  alias MusicQuiz.{Repo, Genre, Quiz}

  def seed("album_authors") do
    Enum.each(Repo.all(Quiz), fn(quiz) ->
      genre = quiz_genre(quiz) |> Repo.preload(:artist)
      albums = Genre.albums(genre)
      Enum.each(albums, fn(album) -> insert_match_song_to_album(album) end)
    end)
  end

  defp insert_match_song_to_album(album) do
    # Get list of songs belonging to album
      # Select ONE at random
    # Get list of songs NOT belonging to album
      # Select THREE at random
    # Insert question "What album includes the song x?"
    # Insert random song from album as answer to question
    # Insert random songs not from album as responses to question
  end

  defp quiz_genre(quiz), do: (quiz |> Repo.preload(:genre)).genre
end
