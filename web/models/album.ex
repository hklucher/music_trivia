defmodule MusicQuiz.Album do
  use MusicQuiz.Web, :model

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
end
