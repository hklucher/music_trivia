defmodule MusicQuiz.AlbumTest do
  use MusicQuiz.ModelCase
  alias MusicQuiz.Album
  import MusicQuiz.Factory

  test ".tracks returns a list of tracks belonging to the given album" do
    track_1 = insert(:track)
    track_2 = insert(:track, name: "Scott's a Dork")
    album = insert(:album, tracks: [track_1, track_2])
    assert Album.tracks(album.id) == [track_1, track_2]
  end

  test ".tracks accepts a track struct or an id" do
    track_1 = insert(:track)
    track_2 = insert(:track, name: "Scott's a Dork")
    album = insert(:album, tracks: [track_1, track_2])
    assert Album.tracks(album.id) == [track_1, track_2]
    assert Album.tracks(album) == [track_1, track_2]
  end

  test ".tracks does not include tracks not belonging to the given album" do
    track_1 = insert(:track)
    track_2 = insert(:track, name: "Sell Out")
    album = insert(:album, tracks: [track_1])
    refute Enum.member?(Album.tracks(album), track_2)
  end

  test ".not_owned_tracks retuns a list of tracks NOT belonging to the given album" do
    track_1 = insert(:track, name: "Reptilia")
    track_2 = insert(:track, name: "Between Love & Hate")
    insert(:album, name: "Room on Fire", tracks: [track_1, track_2])
    album = insert(:album, tracks: [insert(:track)])
    assert Album.not_owned_tracks(album.id) == [track_1, track_2]
  end
end
