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
    artist_id = (Album |> Repo.get(album_id) |> Repo.preload(:artist)).id
    genre_query =
      from g in Genre,
        join: ag in "artist_genres",
        on: ag.genre_id == g.id,
        join: a in Artist,
        on: a.id == ag.artist_id,
        where: a.id == ^artist_id
    artist_genres = Repo.all(genre_query)
    # Track
    # |> Repo.all
    # |> Repo.preload(:albums)
    # |> Enum.reject(fn(t) -> Enum.member?(t.albums, album) end)
    # |> Enum.uniq_by(&(&1.name))
    # |> Enum.shuffle
    # |> Enum.take(limit)
  end
end

# GET artist id
# Repo.get(Album, id) |> Repo.preload(:artist).id

# GET albums genre
# SELECT * FROM genres g
# INNER JOIN artist_genres ag
# ON ag.genre_id == g.id
# INNER JOIN artists a
# ON a.id = ag.artist_id
# WHERE a.id = ^artist_id
