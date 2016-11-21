defmodule MusicQuiz.Seeds.Questions.TrackLengths do
  alias MusicQuiz.{Quiz, Question, Genre, Repo, Answer, Response}

  def seed do
    Enum.each(Repo.all(Quiz), fn(quiz) ->
      current_genre = quiz_genre(quiz)
      if length(Genre.tracks(current_genre)) > 2 do
        tracks_by_genre = Genre.tracks(current_genre) |> Enum.take_random(2)
        answer = create_answer("#{Enum.max_by(tracks_by_genre, fn(t) -> t.duration_ms end).name}")
        distractor_text = Enum.min_by(tracks_by_genre, fn(t) -> t.duration_ms end).name
        question = Question.changeset(%Question{content: "Which of the following is the longer song?"})
        insert_question(question, answer, distractor_text, quiz)
      end
    end)
  end

  defp insert_question(question, answer, distractor, quiz) do
    case Repo.insert(question) do
      {:ok, changeset} ->
        changeset = Repo.preload(changeset, [:answer, :quizzes])
        changeset
        |> Ecto.Changeset.change
        |> Ecto.Changeset.put_assoc(:answer, answer)
        |> Ecto.Changeset.put_assoc(:quizzes, changeset.quizzes ++ [quiz])
        |> Repo.update!
        create_distractor_for(changeset, distractor)
      {:error, changeset} ->
        IO.puts "error inserting question for track run times"
    end
  end

  defp create_answer(content) do
    Repo.insert!(Answer.changeset(%Answer{content: content}))
  end

  defp create_distractor_for(question, distractor) do
    Repo.insert!(Response.changeset(%Response{content: distractor, question_id: question.id}))
  end

  defp quiz_genre(quiz), do: (quiz |> Repo.preload(:genre)).genre
end
