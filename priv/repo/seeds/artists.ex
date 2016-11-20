defmodule MusicQuiz.Seeds.Artists do
  alias MusicQuiz.{Spotify, Repo, Artist, Genre}
  @moduledoc """
  Script to insert Artists and Genres from Spotify API into DataBase
  """

  def seed(start_year, end_year) do
    Enum.each(start_year..end_year, fn(year) ->
      %HTTPoison.Response{body: %{"artists" => artists}} = Spotify.get!("search?q=year%3A#{year}&type=artist")
      insert_artists(artists)
    end)
  end

  defp insert_artists(json) do
    %{"href" => _, "items" => artists} = json
    Enum.each(artists, fn(artist) ->
      attributes = parse_artist_attributes(artist)
      case Repo.insert(Artist.changeset(%Artist{}, attributes)) do
        {:ok, changeset} ->
          build_artist_genres(changeset, artist["genres"])
        {:error, _changeset} ->
          IO.puts "Artist already exists, continuing without insertion."
      end
    end)
  end

  defp parse_artist_attributes(artist_map) do
    artist_map
    |> Map.take(["name", "popularity", "id"])
    |> Map.put("spotify_id", artist_map["id"])
    |> Map.delete("id")
    |> Map.put("image_url", get_image_url(artist_map))
  end

  defp get_image_url(map), do: (Enum.at(map["images"], 0))["url"]

  defp build_artist_genres(artist, genres) do
    Enum.each(genres, fn(genre) ->
      case Repo.insert(Genre.changeset(%Genre{}, %{name: genre})) do
        {:ok, changeset} ->
          changeset
          |> Repo.preload(:artists)
          |> Ecto.Changeset.change
          |> Ecto.Changeset.put_assoc(:artists, [artist])
          |> Repo.update!
        {:error, _changeset} ->
          genre = Repo.get_by!(Genre, name: genre) |> Repo.preload(:artists)
          genre
          |> Ecto.Changeset.change
          |> Ecto.Changeset.put_assoc(:artists, genre.artists ++ [artist])
          |> Repo.update!
      end
    end)
  end
end

MusicQuiz.Spotify.start
MusicQuiz.Seeds.Artists.seed(1980, 1982)
