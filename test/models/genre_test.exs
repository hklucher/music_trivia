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

  test ".albums does not include albums not written by artists of that genre" do
    ska = insert(:genre)
    jazz = insert(:genre, name: "Jazz")
    ska_artist = insert(:artist, genres: [ska])
    insert(:artist, name: "Ella Fitzgerald", genres: [jazz], spotify_id: "1")
    insert(:album, artist: ska_artist)
    jazz_album = insert(:album, name: "Songs in a Mellow Mood")
    album_titles_for_ska = Genre.albums(ska) |> Enum.map(fn(x) -> x.name end)
    refute Enum.member?(album_titles_for_ska, jazz_album.name)
  end
end
