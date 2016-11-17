require IEx;
defmodule MusicQuiz.Seeds.Tracks do
  alias MusicQuiz.Spotify
  alias MusicQuiz.Track
  alias MusicQuiz.Repo
  @moduledoc """
  Module to seed track data from Spotify into DB
  """

  def seed(%{"album_range" => albums}) do
    Enum.each(albums, fn(album) ->
      {:ok, %{"href" => _, "items" => tracks}} = Spotify.album_tracks(album.spotify_id)
      Enum.each(tracks, fn(track) ->
        changeset = build_changeset_from_track(track)
        IEx.pry
      end)
    end)
    # FOR EACH album IN albums
      # GET list of tracks from Spotify
      # IF response ~ 200
        # FOR EACH track IN tracks
          # INSERT track, with association to album
          # Slumber!
        # END FOR
      # ELSE
        # Terminate program
    # END FOR
  end

  defp build_changeset_from_track(track) do
    data = track
           |> Map.take(["name", "preview_url", "duration_ms", "track_number"])
           |> Map.put("spotify_id", track["id"])
    Track.changeset(%Track{}, data)
  end
end
