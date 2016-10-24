defmodule MusicQuiz.Repo.Migrations.CreateArtistGenres do
  use Ecto.Migration

  def change do
    create table(:artist_genres, primary_key: false) do
      add :artist_id, references(:artists)
      add :genre_id, references(:genres)
    end
  end
end
