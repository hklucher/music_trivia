require IEx;
defmodule MusicQuiz.Seeds.Questions do
  alias MusicQuiz.{Repo, Genre, Quiz, Album, Question}

  def seed(:album_authors) do
  Enum.each(Repo.all(Quiz), fn(quiz) ->
      genre = quiz_genre(quiz) |> Repo.preload(:artists)
      albums = Genre.albums(genre)
      Enum.each(albums, fn(album) -> insert_match_song_to_album(album) end)
    end)
  end

  defp insert_match_song_to_album(album) do
    correct = Enum.random(Album.tracks(album)) # Correct answer.
    answer = Repo.insert(Answer.changeset(%Answer{content: correct.name}))

    # Get random song from album
    # Get 3 random songs not from album
    # Create answer from random song
    # Create responses from random songs
    # Create question, associate that with answer and responses
  end

  defp quiz_genre(quiz), do: (quiz |> Repo.preload(:genre)).genre
end

# MusicQuiz.Seeds.Questions.seed(:album_authors)
