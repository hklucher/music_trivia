defmodule MusicQuiz.Repo.Migrations.CreateQuizzes do
  use Ecto.Migration

  def change do
    create table(:quizzes) do
      add :name, :string
      add :genre_id, references(:genres)

      timestamps
    end

    create unique_index(:quizzes, [:name])
  end
end
