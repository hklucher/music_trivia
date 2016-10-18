defmodule MusicQuiz.Repo.Migrations.CreateArtistGenres do
  use Ecto.Migration

  def change do
    create table(:artist_genres) do
      add :artist_id, :integer
      add :genre_id, :integer
    end
  end
end
