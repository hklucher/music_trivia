defmodule MusicQuiz.Repo.Migrations.CreateAlbums do
  use Ecto.Migration

  def change do
    create table(:albums) do
      add :name, :string
      add :spotify_id, :string
      add :image_url, :string
      add :artist_id, references(:artists)

      timestamps
    end

    create unique_index(:albums, [:name])
  end
end
