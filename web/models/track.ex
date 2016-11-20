defmodule MusicQuiz.Track do
  use MusicQuiz.Web, :model
  alias MusicQuiz.Album
  alias MusicQuiz.Repo
  alias MusicQuiz.Track

  schema "tracks" do
    field :name, :string
    field :preview_url, :string
    field :spotify_id, :string
    field :duration_ms, :integer
    field :track_number, :integer

    many_to_many :albums, MusicQuiz.Album, join_through: "album_tracks"

    timestamps

    @required_fields [:name, :spotify_id, :duration_ms, :track_number]

  end

  def changeset(track, params \\ %{}) do
    track
    |> cast(params, [:name, :preview_url, :spotify_id, :duration_ms, :track_number])
    |> validate_required(@required_fields)
  end

  # TODO: Figure out how to add limit as a keyword argument with a default of 15
  def not_on_album(album, limit \\ 15) do
    album_id = album.id
    query =
      from t in Track,
        join: at in "album_tracks",
        on: at.track_id == t.id,
        join: a in "albums",
        on: at.album_id == a.id,
        where: at.album_id != ^album_id,
        limit: ^limit
    Repo.all(query)
  end
end
