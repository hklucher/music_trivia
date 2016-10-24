defmodule MusicQuiz.Album do
  use MusicQuiz.Web, :model

  schema "albums" do
    field :name, :string
    field :image_url, :string
    field :spotify_id, :string

    belongs_to :artist, MusicQuiz.Artist

    timestamps
  end

  def changeset(album, params \\ %{}) do
    album
    |> cast(params, [:name, :image_url, :spotify_id])
    |> validate_required(@required_fields)
  end
end
