defmodule MusicQuiz.Seeds.Questions.MatchArtistsToAlbums do
  alias MusicQuiz.{Repo, Genre, Artist, Question, Answer, Response}

  def seed, do: seed(genres: Repo.all(Genre))

  def seed(genres: [head | tail]) do
    albums_for_genre = Genre.albums(head)
    seed(albums: albums_for_genre)
    seed(genres: tail)
  end

  def seed(genres: []), do: :ok

  def seed(albums: [head | tail]) do
    album = Repo.preload(head, :artist)
    question_content = "What band or artist released the album '#{album.name}'?"
    question = Question.changeset(%Question{}, content: question_content)
    answer = build_answer(album)
    distractors = build_distractors(album)
    insert_question_with_associations(question: question, answer: answer, distractors: distractors)
  end

  def seed(albums: []), do: :ok

  defp insert_question_with_associations(question: changeset, answer: answer, distractors: distractors) do
    case Repo.insert(changeset) do
      {:ok, changeset} ->
        question = Repo.preload(changeset, [:answer, :responses])
        question
        |> Ecto.Changeset.change
        |> Ecto.Changeset.put_assoc(:answer, answer)
        |> Ecto.Changeset.put_assoc(:responses, question.responses ++ distractors)
        |> Repo.update!
      {:error, _changeset} ->
        IO.puts "error inserting question, continuing..."
    end
  end

  defp build_distractors(album) do
    distractor_albums = Enum.take_random(Artist.not_owned_albums(album), 3)
    build_distractors(album, distractor_albums)
  end

  defp build_distractors(album, [head | tail], results \\ []) do
    distractor = Repo.insert(Response.changeset(%Response{}, %{content: album.name}))
    build_distractors(album, tail, results ++ [distractor])
  end

  defp build_distractors(album, [], results), do: results

  defp build_answer(album) do
    changeset = Answer.changeset(%Answer{}, %{content: album.artist.name})
    Repo.insert!(changeset)
  end
end

# FOR genre in ALL genres
  # Get list of albums associated with that genre
  # FOR EACH album IN albums
    # Build changeset of question with content "What band or artist released the album 'album'?"
    # IF changeset is inserted
      # Insert an answer with the content of the albums artist
      # Get three random artists who did not release the current album
      # Insert those as distractors
      # Associate these with question
    # ELSE
      # Print out warning message, continue.
    # END IF
  # END FOR
# END FOR
