defmodule MusicQuiz.Artist do
  use MusicQuiz.Web, :model
  alias MusicQuiz.Repo
  alias MusicQuiz.Artist
  alias MusicQuiz.Album
  alias MusicQuiz.Genre

  schema "artists" do
    field :name, :string
    field :popularity, :integer
    field :image_url, :string
    field :spotify_id, :string

    has_many :albums, MusicQuiz.Album

    many_to_many :genres, MusicQuiz.Genre, join_through: "artist_genres"

    timestamps

    @required_fields [:name, :popularity, :image_url, :spotify_id]
  end

  def changeset(artist, params \\ %{}) do
    artist
    |> cast(params, [:name, :popularity, :image_url, :spotify_id])
    |> validate_required(@required_fields)
    |> unique_constraint(:name, name: :artists_name_index)
    |> unique_constraint(:spotify_id, name: :spotify_id)
    |> cast_assoc(:genres)
  end

    # Scopes/Filters

  def by_genre(genre_id) do
    query = from a in Artist,
              join: a_g in "artist_genres",
              on: a.id == a_g.artist_id,
              join: g in Genre,
              on: g.id == a_g.genre_id,
              where: g.id == ^genre_id,
              select: a
    Repo.all(query)
  end

  def not_owned_albums(artist_id) do
    query = from a in Album,
              where: a.artist_id != ^artist_id,
              select: a
    Repo.all(query)
  end

  def who_have_albums do
    query = from a in Artist,
              join: al in Album,
              where: a.id == al.artist_id,
              select: a
    Repo.all(query) |> Repo.preload(:albums)
  end
end
