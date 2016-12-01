defmodule MusicQuiz.CompletedQuiz do
  use MusicQuiz.Web, :model

  @required_fields [:name, :score, :total_questions]
  
  schema "completed_quizzes" do
    field :name, :string
    field :score, :integer
    field :total_questions, :integer

    belongs_to :user, MusicQuiz.User

    timestamps
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :score, :total_questions])
    |> cast_assoc(:user)
    |> validate_required(@required_fields)
  end
end
