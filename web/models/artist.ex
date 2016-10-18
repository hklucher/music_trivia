defmodule MusicQuiz.Artist do
  use MusicQuiz.Web, :model

  schema "artists" do
    field :name, :string
    field :popularity, :integer
    field :image_url, :string
    field :spotify_id, :string

    many_to_many :genres, MusicQuiz.Genre, join_through: "artist_genres"

    timestamps
  end
end
