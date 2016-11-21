require IEx;
defmodule MusicQuiz.Seeds.Questions do
  alias MusicQuiz.{Repo, Genre, Quiz, Question, Answer, Album, Response, Track}

  # Creates 'Which of the following tracks appears on X?' questions.
  def seed(:match_song_to_album) do
    Enum.each(Repo.all(Quiz), fn(quiz) ->
      current_genre = quiz_genre(quiz)
      Enum.each(Genre.albums(current_genre), fn(album) ->
        if length(Album.tracks(album)) > 0 do
          answer = create_answer_for(album)
          content = "Which of the following tracks appears on the album #{album.name}?"
          changeset = Question.changeset(%Question{content: content})
          insert_question_with_associations(changeset, %{"answer" => answer, "quiz" => quiz, "album" => album})
        end
      end)
    end)
  end

  def seed(:track_run_times) do
    Enum.each(Repo.all(Quiz), fn(quiz) ->
      current_genre = quiz_genre(quiz)
      tracks_by_genre = Genre.tracks(current_genre) |> Enum.take_random(2)
      answer = Enum.max_by(tracks_by_genre, fn(t) -> t.duration_ms end).name
      distractor = Enum.min_by(tracks_by_genre, fn(t) -> t.duration_ms end).name
      question = Question.changeset(%Question{content: "Which of the following is the longer song?"})
      insert_track_run_time_question
    end)
  end

  defp insert_track_run_time_question(question, answer, distractor, quiz) do
    case Repo.insert(question) do
      {:ok, changeset} ->
        changeset = Repo.preload(changeset, [:answer, :quizzes])
        changeset
        |> Ecto.Changeset.change
        |> Ecto.Changeset.put_assoc(:answer, answer)
        |> Ecto.Changeset.put_assoc(:quizzes, changeset.quizzes ++ [quiz])
        |> Repo.update!
        create_distractor_for(changeset)
      {:error, changeset} ->
        IO.puts "error inserting question for track run times"
    end
  end

  defp insert_question_with_associations(changeset, %{"answer" => answer, "quiz" => quiz, "album" => album}) do
    case Repo.insert(changeset) do
      {:ok, changeset} ->
        changeset = changeset |> Repo.preload([:answer, :quizzes])
        changeset
        |> Ecto.Changeset.change
        |> Ecto.Changeset.put_assoc(:answer, answer)
        |> Ecto.Changeset.put_assoc(:quizzes, changeset.quizzes ++ [quiz])
        |> Repo.update!
        create_distractors_for(changeset, album)
      {:error, _changeset} ->
        IO.puts "Insertion failed, continuing."
    end
  end

  defp create_answer_for(album) do
    answer_content = Enum.random(Album.tracks(album)).name
    changeset = Answer.changeset(%Answer{content: answer_content})
    case Repo.insert(changeset) do
      {:ok, changeset} ->
        changeset
      {:error, _changeset} ->
        IO.puts "error inserting answer"
        System.halt(0)
    end
  end

  defp create_distractors_for(question, album) do
    distractor_tracks = Enum.take_random(Album.not_owned_tracks(album.id), 3)
    Enum.each(distractor_tracks, fn(track) ->
      Repo.insert(Response.changeset(%Response{content: track.name, question_id: question.id}))
    end)
  end

  defp quiz_genre(quiz), do: (quiz |> Repo.preload(:genre)).genre
end
