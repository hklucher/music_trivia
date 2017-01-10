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
    genres = Artist.genres(artist_id)
     Track
    |> Repo.all
    |> Repo.preload(:albums)
    |> Enum.reject(fn(t) -> Enum.member?(t.albums, album) end)
    |> Enum.uniq_by(&(&1.name))
    |> Enum.shuffle
    |> Enum.take(limit)
  end
end
