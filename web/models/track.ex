defmodule MusicQuiz.Track do
  use MusicQuiz.Web, :model

  schema "tracks" do
    field :name, :string
    field :preview_url, :string
    field :spotify_id, :string
    field :duration_ms, :integer
    field :track_number, :integer

    many_to_many :albums, MusicQuiz.Album, join_through: "album_tracks"

    timestamps

    @required_fields [:name, :preview_url, :spotify_id, :duration_ms, :track_number]

    def changeset(track, params \\ %{}) do
      track
      |> cast(params, [:name, :preview_url, :spotify_id, :duration_ms, :track_number])
      |> validate_required(@required_fields)
    end
  end
end
