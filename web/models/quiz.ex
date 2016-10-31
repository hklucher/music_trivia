defmodule MusicQuiz.Quiz do
  use MusicQuiz.Web, :model

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
end
