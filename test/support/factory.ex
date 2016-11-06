defmodule MusicQuiz.Factory do
  use ExMachina.Ecto, repo: MusicQuiz.Repo
  alias MusicQuiz.Quiz

  def quiz_factory do
    %Quiz{
      name: "Classic Rock Quiz"
    }
  end
end
