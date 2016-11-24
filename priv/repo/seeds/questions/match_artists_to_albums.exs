defmodule MusicQuiz.Seeds.Questions.MatchArtistsToAlbums do
  alias MusicQuiz.{Repo, Genre, Artist, Question, Answer, Response, Quiz}

  def seed, do: seed(quizzes: Repo.all(Quiz))

  def seed(quizzes: [quiz | tail]) do
    genre = Repo.preload(quiz, :genre).genre
    seed(genre: genre, quiz: quiz)
    seed(quizzes: tail)
  end

  def seed(quizzes: []), do: :ok

  def seed(genre: genre, quiz: quiz) do
    albums_for_genre = Genre.albums(genre)
    seed(albums: albums_for_genre, quiz: quiz)
  end

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
