defmodule MusicQuiz.CompletedQuiz do
  use MusicQuiz.Web, :model
  alias MusicQuiz.CompletedQuiz
  alias MusicQuiz.Repo

  schema "completed_quizzes" do
    field :correct, :integer
    field :possible, :integer
    field :name, :string

    belongs_to :user, MusicQuiz.User

    timestamps
  end

  def percent_correct(id) do
    quiz = Repo.get!(CompletedQuiz, id)
    decimal = "#{quiz.correct / quiz.possible}%"
    [data] = Regex.run(~r/\.[0-9]+/, decimal)
    String.replace(data, ".", "") <> "%"
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:correct, :possible, :name])
    |> validate_required([:correct, :possible, :name])
  end
end
