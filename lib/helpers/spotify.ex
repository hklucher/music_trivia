defmodule MusicQuiz.Spotify do
  @moduledoc """
  A wrapper for hitting the Spotify Web API.
  """

  @base_url "https://api.spotify.com/v1/"

  use HTTPoison.Base

  def process_url(url) do
    @base_url <> url
  end

  def process_response_body(body) do
    body |> Poison.decode!
  end

  def albums(spotify_id) do
    response = get!("artists/#{spotify_id}/albums")
    case response do
      %HTTPoison.Response{body: %{"error" => %{"message" => message, "status" => _status}}} ->
        {:error, message}
      %HTTPoison.Response{body: albums_json} ->
        {:ok, albums_json}
    end
  end

  def album(album_id) do
    response = get!("albums/#{album_id}")
    case response do
      %HTTPoison.Response{body: %{"error" => %{"message" => message, "status" => _status}}} ->
        {:error, message}
      %HTTPoison.Response{body: album_data} ->
        {:ok, album_data}
    end
  end

  def album_tracks(album_spotify_id) do
    response = get!("albums/#{album_spotify_id}/tracks")
    case response do
      %HTTPoison.Response{body: %{"error" => %{"message" => message, "status" => _status}}} ->
        {:error, message}
      %HTTPoison.Response{body: tracks} ->
        {:ok, tracks}
    end
  end
end
