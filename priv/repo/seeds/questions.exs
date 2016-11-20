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
    correct_answer = Album.tracks(album) |> Enum.random
    distractors = Album.not_owned_tracks(album.id) |> Enum.take_random(3)
    changeset = Question.changeset(%Question{content: "What album includes the song #{correct_answer.name}"})
    case Repo.insert(changeset) do
      {:ok, changeset} ->
        changeset = changeset |> Repo.preload([:answer, :responses])
        changeset
        |> Ecto.Changeset.change
        |> Ecto.Changeset.put_assoc(:answer, correct_answer)
        |> Ecto.Changeset.put_assoc(:responses, changeset.responses ++ distractors)
        |> Repo.update!
      {:error, changeset} ->
        IO.inspect changeset.errors
        System.halt(0)
    end
  end

  defp quiz_genre(quiz), do: (quiz |> Repo.preload(:genre)).genre
end

# MusicQuiz.Seeds.Questions.seed(:album_authors)
