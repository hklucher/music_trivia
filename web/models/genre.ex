defmodule MusicQuiz.Genre do
  use MusicQuiz.Web, :model
  alias MusicQuiz.Album
  alias MusicQuiz.Repo

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

  def albums(genre) do
    query =
      from a in Album,
        join: ar in assoc(a, :artist),
        join: g in assoc(ar, :genres),
        where: g.id == ^genre.id
    Repo.all(query)
  end
end
