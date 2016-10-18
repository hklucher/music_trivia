defmodule MusicQuiz.Seeds do
  @genre_base_url "https://api.spotify.com/v1/browse/categories"

  def seed_genres do
    HTTPoison.start
    token = get_access_token
    HTTPoison.get!(@genre_base_url, ["Accept": "application/json", "Authorization": "Bearer #{token}"])
    |> parse_json
    |> insert_genres
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

MusicQuiz.Seeds.seed_genres
