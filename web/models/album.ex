defmodule MusicQuiz.Album do
  use MusicQuiz.Web, :model
  alias MusicQuiz.{Repo, Album, Track}

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

  def not_owned_tracks(id, limit \\ 50) when is_integer(id) do
    query = from t in Track,
              inner_join: at in "album_tracks",
              on: at.track_id == t.id,
              inner_join: a in "albums",
              on: at.album_id == a.id,
              where: a.id != ^id,
              limit: ^limit
    query |> Repo.all |> Enum.uniq_by(&(&1.name))
  end
end
