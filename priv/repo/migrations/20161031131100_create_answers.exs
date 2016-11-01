defmodule MusicQuiz.Repo.Migrations.CreateAnswers do
  use Ecto.Migration

  def change do
    create table(:answers) do
      add :content, :string

      timestamps
    end
  end
end
