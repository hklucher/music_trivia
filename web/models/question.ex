defmodule MusicQuiz.Question do
  use MusicQuiz.Web, :model

  schema "questions" do
    field :content, :string

    many_to_many :quizzes, MusicQuiz.Quiz, join_through: "quiz_questions"
    belongs_to :answer, MusicQuiz.Answer
    has_many :responses, MusicQuiz.Response

    timestamps
  end

  def changeset(question, params \\ %{}) do
    question
    |> cast(params, [:content])
    |> validate_required([:content])
    |> unique_constraint([:content])
  end
end
