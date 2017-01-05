defmodule MusicQuiz.Quiz do
  use MusicQuiz.Web, :model

  alias MusicQuiz.Question
  alias MusicQuiz.Repo
  alias MusicQuiz.Quiz

  schema "quizzes" do
    field :name, :string

    many_to_many :questions, MusicQuiz.Question, join_through: "quiz_questions"
    belongs_to :genre, MusicQuiz.Genre

    timestamps
  end

  def changeset(quiz, params \\ %{}) do
    quiz
    |> cast(params, [:name, :genre_id])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> cast_assoc(:genre)
  end

  def questions_for_use(quiz_id) when is_integer(quiz_id) do
    quiz_id |> query_for_questions |> Repo.all |> Enum.take_random(20)
  end

  def questions_for_use(quiz) do
    quiz.id |> query_for_questions |> Repo.all |> Enum.take_random(20)
  end

  def have_questions do
    Quiz
    |> Repo.all
    |> Repo.preload(:questions)
    |> Enum.filter(fn(q) -> length(q.questions) >= 1 end)
  end

  defp query_for_questions(quiz_id) do
    from q in Question,
      join: qq in "quiz_questions",
      on: qq.question_id == q.id,
      join: quiz in "quizzes",
      on: qq.quiz_id == quiz.id,
      where: qq.quiz_id == ^quiz_id
  end
end
