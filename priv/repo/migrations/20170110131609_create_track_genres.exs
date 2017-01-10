defmodule MusicQuiz.Repo.Migrations.CreateTrackGenres do
  use Ecto.Migration

  def change do
    create_table(:track_genres) do
      add :track_id, references(:tracks)
      add :genre_id, references(:genres)
    end
  end
end
