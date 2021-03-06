defmodule MusicQuiz.Seeds.Tracks do
  alias MusicQuiz.Spotify
  alias MusicQuiz.Track
  alias MusicQuiz.Repo
  alias MusicQuiz.Artist

  def seed(%{"album_range" => albums}) do
    Enum.each(albums, fn(album) ->
      {:ok, %{"href" => _, "items" => tracks}} = Spotify.album_tracks(album.spotify_id)

      album_artist = (album |> Repo.preload(:artist)).artist
      genres = Artist.genres(album_artist.id)

      Enum.each(tracks, fn(track) ->
        changeset = build_changeset_from_track(track)
        case Repo.insert(changeset) do
          {:ok, changeset} ->
            changeset = changeset |> Repo.preload([:albums, :genres])
            changeset
            |> Ecto.Changeset.change
            |> Ecto.Changeset.put_assoc(:albums, changeset.albums ++ [album])
            |> Ecto.Changeset.put_assoc(:genres, changeset.genres ++ genres)
            |> Repo.update!
            :timer.sleep(1000)
          {:error, changeset} ->
            IO.inspect changeset.errors
            System.halt(0)
        end
      end)
    end)
  end

  defp build_changeset_from_track(track) do
    data =
      track
      |> Map.take(["name", "preview_url", "duration_ms", "track_number"])
      |> Map.put("spotify_id", track["id"])
    Track.changeset(%Track{}, data)
  end
end
