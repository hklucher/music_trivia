defmodule MusicQuiz.Repo.Migrations.CreateGenres do
  use Ecto.Migration

  def change do
    create table(:genres) do
      add :name, :string
      add :artist_genre_id, :integer

      timestamps
    end
  end
end
