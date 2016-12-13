defmodule MusicQuiz.CompletedQuiz do
  use MusicQuiz.Web, :model

  schema "completed_quizzes" do
    field :correct, :integer
    field :possible, :integer
    field :name, :string
    
    belongs_to :user, MusicQuiz.User

    timestamps
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:correct, :possible, :name])
    |> validate_required([:correct, :possible, :name])
  end
end
