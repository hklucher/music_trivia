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
end
