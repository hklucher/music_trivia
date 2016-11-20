defmodule MusicQuiz.Album do
  use MusicQuiz.Web, :model
  alias MusicQuiz.Repo
  alias MusicQuiz.Album

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
    (Repo.get(Album, id) |> Repo.preload(:tracks)).tracks
  end

  def tracks(album) do
    (Repo.get(Album, album.id) |> Repo.preload(:tracks)).tracks
  end
end
