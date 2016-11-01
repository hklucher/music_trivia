defmodule MusicQuiz.Repo.Migrations.CreateQuizQuestions do
  use Ecto.Migration

  def change do
    create table(:quiz_questions, primary_key: false) do
      add :quiz_id, references(:quizzes), on_replace: :nilify
      add :question_id, references(:questions), on_replace: :nilify
    end
  end
end
