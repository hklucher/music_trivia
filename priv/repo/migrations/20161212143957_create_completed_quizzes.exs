defmodule MusicQuiz.Repo.Migrations.CreateCompletedQuizzes do
  use Ecto.Migration

  def change do
    create table(:completed_quizzes) do
      add :correct, :integer
      add :possible, :integer
      # TODO: Check if I need a user_id or if Ecto does this for me.
      add :user_id,  :integer

      timestamps
    end
  end
end
