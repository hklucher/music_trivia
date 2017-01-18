require IEx

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
end
