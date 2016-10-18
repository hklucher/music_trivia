defmodule MusicQuiz.Repo.Migrations.CreateArtists do
  use Ecto.Migration

  def change do
    create table(:artists) do
      add :name, :string
      add :popularity, :integer
      add :image_url, :string
      add :spotify_id, :string
      add :artist_genre_id, :integer

      timestamps
    end
  end
end
