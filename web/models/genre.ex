defmodule MusicQuiz.Genre do
  @moduledoc """
  Represents a genre of music. Has many artists and many quizzes. 
  """
  use MusicQuiz.Web, :model
  alias MusicQuiz.Album
  alias MusicQuiz.Repo
  alias MusicQuiz.Track

  schema "genres" do
    field :name, :string

    many_to_many :artists, MusicQuiz.Artist, join_through: "artist_genres"
    has_many :quizzes, MusicQuiz.Quiz

    timestamps
  end

  @required_fields ~w(name)

  def changeset(genre, params \\ %{}) do
    genre
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

  def albums(id) when is_integer(id) do
    query =
      from a in Album,
        join: ar in assoc(a, :artist),
        join: g in assoc(ar, :genres),
        where: g.id == ^id
    Repo.all(query)
  end

  def albums(genre) do
    query =
      from a in Album,
        join: ar in assoc(a, :artist),
        join: g in assoc(ar, :genres),
        where: g.id == ^genre.id
    Repo.all(query)
  end

  def tracks(genre_id) when is_integer(genre_id), do: Repo.all(query_for_genres(genre_id))
  def tracks(genre), do: Repo.all(query_for_genres(genre.id))

  defp query_for_genres(genre_id) do
    from t in Track,
      join:  at in "album_tracks",
      on: at.track_id == t.id,
      join: a in "albums",
      on: at.album_id == a.id,
      join: ar in "artists",
      on: a.artist_id == ar.id,
      join: ag in "artist_genres",
      on: ag.artist_id == ar.id,
      join: g in "genres",
      on: ag.genre_id == g.id,
      where: g.id == ^genre_id
  end
end
