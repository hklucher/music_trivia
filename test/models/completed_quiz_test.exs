defmodule MusicQuiz.QuizTest do
  use MusicQuiz.ModelCase
  alias MusicQuiz.CompletedQuiz
  import MusicQuiz.Factory

  @valid_attrs %{correct: 15, possible: 20, name: "Jazz Quiz"}
  @invalid_attrs %{}

  test "changest with valid attributes" do
    changeset = CompletedQuiz.changeset(%CompletedQuiz{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CompletedQuiz.changeset(%CompletedQuiz{}, @invalid_attrs)
    refute changeset.valid?
  end
end
