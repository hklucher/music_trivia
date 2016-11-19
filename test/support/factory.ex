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

  def question_factory do
    %MusicQuiz.Question{
      content: "Who released 'In the Aeroplane Under the Sea'?"
    }
  end

  def response_factory do
    %MusicQuiz.Response{
      content: "Eagles of Death Metal"
    }
  end

  def answer_factory do
    %MusicQuiz.Answer{
      content: "Neutral Milk Hotel"
    }
  end
end
