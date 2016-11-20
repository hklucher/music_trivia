defmodule MusicQuiz.Seeds.Albums do
  alias MusicQuiz.{Artist, Spotify, Album, Repo}

  def seed, do: seed_albums(Repo.all(Artist))
  def seed([head | tail]), do: seed_albums([head | tail])

  def seed_albums(artists) do
    Enum.each(artists, fn(artist) ->
      case Spotify.albums(artist.spotify_id) do
        {:ok, albums} ->
          Enum.each(albums["items"], fn(album) ->
            create_album(album["id"], artist)
            :timer.sleep(2000)
          end)
        {:error, message} ->
          IO.puts message
      end
    end)
  end

  defp create_album(spotify_id, artist) do
    case Spotify.album(spotify_id) do
      {:ok, album_data} ->
        attributes = parse_album_attributes(album_data, artist)
        case Repo.insert(Album.changeset(%Album{}, attributes)) do
          {:ok, _changeset} ->
            IO.puts "Created album"
          {:error, _changeset} ->
            IO.puts "Error: Did not insert album, continuing..."
        end
      {:error, message} ->
        IO.puts "Error: #{message}"
        System.halt(0)
    end
  end

  def parse_album_attributes(album, artist) do
    album
    |> Map.take(["name", "id"])
    |> Map.put("spotify_id", album["id"])
    |> Map.delete("id")
    |> Map.put("image_url", get_image_url(album))
    |> Map.put("artist_id", artist.id)
  end

  defp get_image_url(map), do: (Enum.at(map["images"], 0))["url"]
end

MusicQuiz.Spotify.start
MusicQuiz.Seeds.Albums.seed
