defmodule MusicQuiz.Artist do
  use MusicQuiz.Web, :model

  schema "artists" do
    field :name, :string
    field :popularity, :integer
    field :image_url, :string
    field :spotify_id, :string

    has_many :albums, MusicQuiz.Album

    many_to_many :genres, MusicQuiz.Genre, join_through: "artist_genres"

    timestamps

    @required_fields [:name, :popularity, :image_url, :spotify_id]

    def changeset(artist, params \\ %{}) do
      artist
      |> cast(params, [:name, :popularity, :image_url, :spotify_id])
      |> validate_required(@required_fields)
      |> unique_constraint(:name)
    end
  end
end
