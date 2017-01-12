defmodule MusicQuiz.Album do
  use MusicQuiz.Web, :model
  alias MusicQuiz.{Repo, Album, Track, Artist, Genre}

  schema "albums" do
    field :name, :string
    field :image_url, :string
    field :spotify_id, :string

    belongs_to :artist, MusicQuiz.Artist, foreign_key: :artist_id
    many_to_many :tracks, MusicQuiz.Track, join_through: "album_tracks"

    timestamps
  end

  @required_fields [:name, :image_url, :spotify_id, :artist_id]

  def changeset(album, params \\ %{}) do
    album
    |> cast(params, [:name, :image_url, :spotify_id, :artist_id])
    |> unique_constraint(:name)
    |> cast_assoc(:artist)
    |> validate_required(@required_fields)
  end

  def tracks(id) when is_integer(id) do
    (Album |> Repo.get(id) |> Repo.preload(:tracks)).tracks
  end

  def tracks(album) do
    (Album |> Repo.get(album.id) |> Repo.preload(:tracks)).tracks
  end

  def not_owned_tracks(album_id, limit \\ 50) when is_integer(album_id) do
    album = Album |> Repo.get!(album_id) |> Repo.preload([:tracks, :artist])
    genre_ids = Artist.genres(album.artist.id) |> Enum.map(&(&1.id))
    query =
      from t in Track,
      join: tg in "track_genres",
      on: tg.track_id == t.id,
      join: g in Genre,
      on: tg.genre_id == g.id,
      where: g.id in ^genre_ids,
      distinct: t.id
    Repo.all(query)
  end
end
