defmodule MusicQuiz.Repo.Migrations.CreateCompletedQuizzes do
  use Ecto.Migration

  def change do
    create table(:completed_quizzes) do
      add :correct, :integer
      add :possible, :integer
      add :name, :string
      timestamps
    end
  end
end
