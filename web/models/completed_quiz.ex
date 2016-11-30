defmodule MusicQuiz.CompletedQuiz do
  use MusicQuiz.Web, :model
  
  schema "completed_quizzes" do
    field :name, :string
    field :score, :integer
    field :total_questions, :integer

    belongs_to :user, MusicQuiz.User

    timestamps
  end

  def changeset(struct, params \\ %{}) do
  end
end
