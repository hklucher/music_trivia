defmodule MusicQuiz.Genre do
  use MusicQuiz.Web, :model

  schema "genres" do
    field :name, :string

    many_to_many :artists, MusicQuiz.Artist, join_through: "artist_genres", on_replace: :delete

    timestamps
  end

  @required_fields ~w(name)

  def changeset(genre, params \\ %{}) do
    genre
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
