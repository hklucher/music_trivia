require IEx;
alias MusicQuiz.Repo
alias MusicQuiz.Genre
alias MusicQuiz.Artist

defmodule MusicQuiz.Seeds do
  @genre_base_url "https://api.spotify.com/v1/browse/categories"

  def seed_genres do
    token = get_access_token
    HTTPoison.get!(@genre_base_url, ["Accept": "application/json", "Authorization": "Bearer #{token}"])
    |> parse_json
    |> insert_genres
  end

  def seed_artists do
    base_year = 1960
    Enum.each(base_year..2000, fn(x) ->
      url = "https://api.spotify.com/v1/search?q=year%3A#{x}&type=artist&market=US"
      json_artists_for_year = HTTPoison.get!(url)
      case Poison.decode(json_artists_for_year.body) do
        {:ok, artists} ->
          artist_list = artists["artists"]["items"]
          Enum.each(artist_list, fn(artist) ->
            Repo.insert!(%Artist{name: artist["name"], popularity: artist["popularity"],
                                image_url: (artist["images"] |> Enum.at(0))["url"],
                                spotify_id: artist["id"]})
            artist_genres = artist["genres"]

            Enum.each(artist_genres, fn(genre) ->
              changeset = Genre.changeset(%Genre{}, %{name: genre})
              Repo.insert(changeset)
            end)
          end)
          IO.puts "Inserted artists. Sleeping, please wait..."
          :timer.sleep(10000) # Don't overload API with requests.
        _ ->
          IO.puts "Error in getting response for #{base_year}, terminating."
          System.halt(0)
      end
    end)
  end

  defp insert_genres([head | tail]) do
    MusicQuiz.Repo.insert!(%MusicQuiz.Genre{name: head["name"]})
    insert_genres(tail)
  end

  defp insert_genres([]), do: :ok

  defp parse_json(data) do
    case Poison.decode(data.body) do
      {:ok, categories} ->
        categories["categories"]["items"]
      _ ->
        {:error, "Error obtaining categories"}
    end
  end

  defp get_access_token do
    auth = Base.encode64("#{Application.get_env(:music_quiz, :spotify_client_id)}:#{Application.get_env(:music_quiz, :spotify_client_secret)}")
    response = HTTPoison.post!("https://accounts.spotify.com/api/token",
                               "grant_type=client_credentials",
                               [{"Authorization", "Basic #{auth}"},
                                {"Content-Type", "application/x-www-form-urlencoded"}])
    case Poison.decode(response.body) do
      {:ok, %{"access_token" => access_token, "expires_in" => _, "token_type" => _}} ->
        access_token
      _ ->
        IO.puts "Error in obtaining access token, terminating."
        System.halt(0)
    end
  end
end

HTTPoison.start
MusicQuiz.Seeds.seed_genres
MusicQuiz.Seeds.seed_artists
