defmodule MusicQuiz.Album do
  use MusicQuiz.Web, :model

  schema "albums" do
    field :name, :string
    field :image_url, :string
    field :spotify_id, :string

    timestamps
  end

  def changeset(artist, params \\ %{}) do
    
  end
end
