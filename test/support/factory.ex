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

  def track_factory do
    %MusicQuiz.Track{
      name: "Brand New Song",
      preview_url: "www.example.com",
      spotify_id: "cba123",
      duration_ms: 5000,
      track_number: 2
    }
  end

  def user_factory do
    %MusicQuiz.User{
      email: "test@example.com",
      crypted_password: Comeonin.Bcrypt.hashpwsalt("password"),
      password: "password"
    }
  end

  def insert_multiple_quizzes(amount) do
    Enum.each(1..amount, fn(i) ->
      quiz_question = insert(:question, content: "question_#{i}")
      insert(:quiz, name: "quiz_#{i}", questions: [quiz_question])
    end)
  end
end
