defmodule MusicQuiz.Repo.Migrations.CreateTracks do
  use Ecto.Migration

  def change do
    create table(:tracks) do
      add :name, :string
      add :preview_url, :string
      add :spotify_id,  :string
      add :duration_ms, :integer
      add :track_number, :integer

      timestamps
    end
  end
end
