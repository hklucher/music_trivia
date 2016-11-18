defmodule MusicQuiz.GenreTest do
  use MusicQuiz.ModelCase
  alias MusicQuiz.Genre

  import MusicQuiz.Factory

  test "with valid attributes" do
    changeset = Genre.changeset(%Genre{name: "ska"})
    assert changeset.valid?
  end

  test "with invalid attributes" do
    changeset = Genre.changeset(%Genre{name: ""})
    refute changeset.valid?
  end

  test ".albums returns all albums written by artists of that genre" do
    genre = insert(:genre)
    artist_for_genre = insert(:artist, genres: [genre])
    album_for_genre = insert(:album, artist: artist_for_genre)
    album_titles_by_genre = Genre.albums(genre) |> Enum.map(fn(x) -> x.name end)
    assert Enum.member?(album_titles_by_genre, album_for_genre.name)
  end
end
