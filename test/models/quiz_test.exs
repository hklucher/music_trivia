defmodule MusicQuiz.QuizTest do
  use MusicQuiz.ModelCase
  alias MusicQuiz.Quiz

  @valid_attrs %{name: "classic rock quiz", genre_id: 1}
  @invalid_attrs %{}

  test "changest with valid attributes" do
    changeset = Quiz.changeset(%Quiz{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changest = Quiz.changeset(%Quiz{}, @invalid_attrs)
    refute changest.valid?
  end
end
