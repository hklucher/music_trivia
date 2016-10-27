require IEx;
alias MusicQuiz.Repo
alias MusicQuiz.Genre
alias MusicQuiz.Artist
alias MusicQuiz.Album
alias MusicQuiz.Spotify

defmodule MusicQuiz.Seeds do
  @genre_base_url "https://api.spotify.com/v1/browse/categories"

  # def seed_genres do
  #   token = get_access_token
  #   HTTPoison.get!(@genre_base_url, ["Accept": "application/json", "Authorization": "Bearer #{token}"])
  #   |> parse_json
  #   |> insert_genres
  # end

  def artists(start_year, end_year) do
    Enum.each(start_year..end_year, fn(year) ->
      %HTTPoison.Response{body: %{"artists" => artists}} = Spotify.get!("search?q=year%3A#{year}&type=artist")
      insert_artists(artists)
    end)
  end

  defp insert_artists(json) do
    %{"href" => _, "items" => artists} = json
    Enum.each(artists, fn(artist) ->
      attributes = artist
      |> Map.take(["name", "popularity", "id"])
      |> Map.put("spotify_id", artist["id"])
      |> Map.delete("id")
      |> Map.put("image_url", get_image_url(artist))

      genres = artist["genres"]
      case Repo.insert(Artist.changeset(%Artist{}, attributes)) do
        {:ok, changeset} ->
          build_artist_genres(changeset, genres)
        {:error, changeset} ->
          IO.puts "Error: artist already exists, continuing without insertion."
      end
    end)
  end

  defp get_image_url(artist), do: (Enum.at(artist["images"], 0))["url"]

  defp build_artist_genres(artist, genres) do
    Enum.each(genres, fn(genre) ->
      current_artist = Repo.get(Artist, artist.id)
      inserted_genre = Repo.insert(Genre.changeset(%Genre{}, %{name: genre}))
      case inserted_genre do
        {:ok, changeset} ->
          changeset
          |> Repo.preload(:artists)
          |> Ecto.Changeset.change
          |> Ecto.Changeset.put_assoc(:artists, [current_artist])
          |> Repo.update!
        {:error, _changeset} ->
          Repo.get_by!(Genre, name: genre)
          |> Repo.preload(:artists)
          |> Ecto.Changeset.change
          |> Ecto.Changeset.put_assoc(:artists, [current_artist])
      end
    end)
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
# HTTPoison.start
# MusicQuiz.Seeds.seed_genres
# MusicQuiz.Seeds.seed_artists
# MusicQuiz.Seeds.seed_albums
