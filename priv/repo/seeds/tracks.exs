require IEx;
alias MusicQuiz.Album
alias MusicQuiz.Repo
alias MusicQuiz.Spotify
defmodule MusicQuiz.Seeds.Tracks do
  alias MusicQuiz.Spotify
  alias MusicQuiz.Track
  @moduledoc """
  Module to seed track data from Spotify into DB
  """

  def seed(%{"album_range" => albums}) do
    Enum.each(albums, fn(album) ->
      {:ok, %{"href" => _, "items" => tracks}} = Spotify.album_tracks(album.spotify_id)
      Enum.each(tracks, fn(track) ->
        changeset = build_changeset_from_track(track)
        case Repo.insert(changeset) do
          {:ok, changeset} ->
            changeset = changeset |> Repo.preload(:albums)
            changeset
            |> Repo.preload(:albums)
            |> Ecto.Changeset.change
            |> Ecto.Changeset.put_assoc(:albums, changeset.albums ++ [album])
            |> Repo.update!
            :timer.sleep(1000)
          {:error, changeset} ->
            IO.puts changeset.errors
            System.halt(0)
        end
      end)
    end)
  end

  defp build_changeset_from_track(track) do
    data = track
           |> Map.take(["name", "preview_url", "duration_ms", "track_number"])
           |> Map.put("spotify_id", track["id"])
    Track.changeset(%Track{}, data)
  end
end

Spotify.start
MusicQuiz.Seeds.Tracks.seed(%{"album_range" => Repo.all(Album, limit: 10)})
