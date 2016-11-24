defmodule MusicQuiz.Seeds.Questions.MatchArtistsToAlbums do
  alias MusicQuiz.{Repo, Genre, Artist, Question, Answer, Response, Quiz}

  # def seed, do: seed(quizzes: Repo.all(Quiz))

  def seed, do: seed(quizzes: Repo.all(Quiz))

  def seed(quizzes: [head | tail]) do
    genre = Repo.preload(head, :genre).genre
    seed(genre: genre, quiz: head)
    seed(quizzes: tail)
  end

  def seed(quizzes: []), do: :ok

  def seed(genres: [head | tail]) do
    albums_for_genre = Genre.albums(head)
    seed(albums: albums_for_genre)
    seed(genres: tail)
  end

  def seed(genre: genre, quiz: quiz) do
    albums_for_genre = Genre.albums(genre)
    seed(albums: albums_for_genre, quiz: quiz)
  end

  def seed(genres: []), do: :ok

  def seed(albums: [head | tail], quiz: quiz) do
    album = Repo.preload(head, :artist)
    question_content = "What band or artist released the album '#{album.name}'?"
    question = Question.changeset(%Question{}, %{content: question_content})
    answer = build_answer(album)
    distractors = build_distractors(album)
    insert_question_with_associations(question: question, answer: answer, distractors: distractors, quiz: quiz)
  end

  def seed(albums: [], quiz: quiz), do: :ok

  defp insert_question_with_associations(question: changeset, answer: answer, distractors: distractors, quiz: quiz) do
    case Repo.insert(changeset) do
      {:ok, changeset} ->
        question = Repo.preload(changeset, [:answer, :responses, :quizzes])
        question
        |> Ecto.Changeset.change
        |> Ecto.Changeset.put_assoc(:answer, answer)
        |> Ecto.Changeset.put_assoc(:responses, question.responses ++ distractors)
        |> Ecto.Changeset.put_assoc(:quizzes, question.quizzes ++ [quiz])
        |> Repo.update!
      {:error, _changeset} ->
        IO.puts "error inserting question, continuing..."
    end
  end

  defp build_distractors(album) do
    # Artist.did_not_write_album(album)
    # It's too god damn loud here to finish this. I'm  building a response from
    # an album instead of artists. Write a query to grab artists who did not
    # release a given album, then pass that as an an argument to take_random
    # and call it distractor_artists instead, you fool.
    distractor_artists = Enum.take_random(Artist.did_not_write_album(album), 3)
    build_distractors(album, distractor_artists)
  end

  defp build_distractors(album, [head | tail], results \\ []) do
    {:ok, distractor} = Repo.insert(Response.changeset(%Response{}, %{content: head.name}))
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
