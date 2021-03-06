defmodule MusicQuiz.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :content, :string
      add :quiz_question_id, :integer
      add :answer_id, references(:answers)

      timestamps
    end
  end
end
