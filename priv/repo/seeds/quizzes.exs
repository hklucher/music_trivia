defmodule MusicQuiz.Seeds.Quizzes do
  alias MusicQuiz.{Repo, Quiz, Genre}

  def seed do
    Enum.each(Repo.all(Genre) |> Repo.preload(:quizzes), fn(genre) ->
      {:ok, quiz} = Repo.insert(Quiz.changeset(%Quiz{}, %{name: "#{genre.name} quiz"}))
      genre
      |> Ecto.Changeset.change
      |> Ecto.Changeset.put_assoc(:quizzes, genre.quizzes ++ [quiz])
      |> Repo.update!
    end)
  end
end

# MusicQuiz.Seeds.Quizzes.seed
