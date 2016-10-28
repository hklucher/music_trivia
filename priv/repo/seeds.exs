require IEx;
alias MusicQuiz.Repo
alias MusicQuiz.Genre
alias MusicQuiz.Artist
alias MusicQuiz.Album
alias MusicQuiz.Spotify

defmodule MusicQuiz.Seeds do
  def artists(start_year, end_year) do
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
        {:error, changeset} ->
          IO.puts "Error: artist already exists, continuing without insertion."
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

  # TODO: Pattern match on argument?
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

  def albums do
    Enum.each(Repo.all(Artist), fn(artist) ->
      case Spotify.albums(artist.spotify_id) do
        {:ok, albums} ->
          Enum.each(albums["items"], fn(album) ->
            create_album(album["id"], artist)
            :timer.sleep(5000)
          end)
        {:error, message} ->
          IEx.pry
      end
    end)
  end

  defp create_album(spotify_id, artist) do
    case Spotify.album(spotify_id) do
      {:ok, album_data} ->
        attributes = parse_album_attributes(album_data, artist)
        case Repo.insert(Album.changeset(%Album{}, attributes)) do
          {:ok, changeset} ->
            IO.puts "Inserted album"
          {:error, changeset} ->
            IO.puts "Could not insert album"
        end
      {:error, message} ->
        IO.puts "Error: #{message}"
        System.halt(0)
    end
  end

  defp associate_album_artist(album, artist) do
    IEx.pry
  end

  def parse_album_attributes(album, artist) do
    album
    |> Map.take(["name", "id"])
    |> Map.put("spotify_id", album["id"])
    |> Map.delete("id")
    |> Map.put("image_url", get_image_url(album))
    |> Map.put("artist_id", artist.id)
  end


  # def seed_artists do
  #   base_year = 1995
  #   Enum.each(base_year..2000, fn(x) ->
  #     url = "https://api.spotify.com/v1/search?q=year%3A#{x}&type=artist&market=US"
  #     json_artists_for_year = HTTPoison.get!(url)
  #     case Poison.decode(json_artists_for_year.body) do
  #       {:ok, artists} ->
  #         artist_list = artists["artists"]["items"]
  #         Enum.each(artist_list, fn(artist) ->
  #           Repo.insert!(%Artist{name: artist["name"], popularity: artist["popularity"],
  #                               image_url: (artist["images"] |> Enum.at(0))["url"],
  #                               spotify_id: artist["id"]})
  #           artist_genres = artist["genres"]
  #
  #           Enum.each(artist_genres, fn(genre) ->
  #             changeset = Genre.changeset(%Genre{}, %{name: genre})
  #             Repo.insert(changeset)
  #           end)
  #         end)
  #         IO.puts "Inserted artists. Sleeping, please wait..."
  #         :timer.sleep(10000) # Don't overload API with requests.
  #       _ ->
  #         IO.puts "Error in getting response for #{base_year}, terminating."
  #         System.halt(0)
  #     end
  #   end)
  # end
  #
  # def seed_albums do
  #   Enum.each(Repo.all(Artist), fn(artist) ->
  #     create_albums_for_artist(HTTPoison.get!("https://api.spotify.com/v1/artists/#{artist.spotify_id}/albums"), artist)
  #     :timer.sleep(10000)
  #   end)
  # end
  #
  # defp create_albums_for_artist(%HTTPoison.Response{status_code: 200, body: body}, artist) do
  #   {:ok, %{"href" => _, "items" => items}} = Poison.decode(body)
  #   Enum.each(items, fn(album) ->
  #     changeset = Album.changeset(%Album{name: album["name"], spotify_id: album["id"],
  #                                        image_url: (album["images"] |> Enum.at(0))["url"],
  #                                        artist_id: artist.id})
  #     Repo.insert!(changeset)
  #   end)
  # end
  #
  # defp create_albums_for_artist(_, _) do
  #   IO.puts "Error in obtaining albums, terminating."
  #   System.halt(0)
  # end
  #
  # defp insert_genres([head | tail]) do
  #   MusicQuiz.Repo.insert!(%MusicQuiz.Genre{name: head["name"]})
  #   insert_genres(tail)
  # end
  #
  # defp insert_genres([]), do: :ok
  #
  # defp parse_json(data) do
  #   case Poison.decode(data.body) do
  #     {:ok, categories} ->
  #       categories["categories"]["items"]
  #     _ ->
  #       {:error, "Error obtaining categories"}
  #   end
  # end
  #
  # defp get_access_token do
  #   auth = Base.encode64("#{Application.get_env(:music_quiz, :spotify_client_id)}:#{Application.get_env(:music_quiz, :spotify_client_secret)}")
  #   response = HTTPoison.post!("https://accounts.spotify.com/api/token",
  #                              "grant_type=client_credentials",
  #                              [{"Authorization", "Basic #{auth}"},
  #                               {"Content-Type", "application/x-www-form-urlencoded"}])
  #   case Poison.decode(response.body) do
  #     {:ok, %{"access_token" => access_token, "expires_in" => _, "token_type" => _}} ->
  #       access_token
  #     _ ->
  #       IO.puts "Error in obtaining access token, terminating."
  #       System.halt(0)
  #   end
  # end
end

Spotify.start
MusicQuiz.Seeds.artists(1970, 1975)
MusicQuiz.Seeds.albums
# HTTPoison.start
# MusicQuiz.Seeds.seed_genres
# MusicQuiz.Seeds.seed_artists
# MusicQuiz.Seeds.seed_albums
