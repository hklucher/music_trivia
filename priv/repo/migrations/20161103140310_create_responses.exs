defmodule MusicQuiz.Repo.Migrations.CreateResponses do
  use Ecto.Migration

  def change do
    create table(:responses) do
      add :content, :string
      add :question_id, references(:questions)

      timestamps
    end
  end
end
