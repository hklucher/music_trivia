defmodule MusicQuiz.Repo.Migrations.CreateCompletedQuizzes do
  use Ecto.Migration

  def change do
    create table(:completed_quizzes) do
      add :name, :string
      add :score, :integer
      add :total_questions, :integer
      add :user_id, references(:users)

      timestamps
    end
  end
end
