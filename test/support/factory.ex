defmodule MusicQuiz.Factory do
  use ExMachina.Ecto, repo: MusicQuiz.Repo

  def genre_factory do
    %MusicQuiz.Genre{
      name: "ska"
    }
  end

  def album_factory do
    %MusicQuiz.Album{
      name: "Why do They Rock so Hard?",
      image_url: "www.example.com",
      spotify_id: "123abc"
    }
  end

  def artist_factory do
    %MusicQuiz.Artist{
      name: "Reel Big Fish",
      popularity: 99,
      image_url: "www.example.com",
      spotify_id: "abc123"
    }
  end

  def quiz_factory do
    %MusicQuiz.Quiz{
      name: "Indie Rock Quiz"
    }
  end
end
