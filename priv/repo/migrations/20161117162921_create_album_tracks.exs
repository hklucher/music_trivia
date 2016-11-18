defmodule MusicQuiz.Repo.Migrations.CreateAlbumTracks do
  use Ecto.Migration

  def change do
    create table(:album_tracks) do
      add :album_id, references(:albums)
      add :track_id, references(:tracks)
    end
  end
end
