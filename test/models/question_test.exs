defmodule MusicQuiz.QuestionTest do
  use MusicQuiz.ModelCase
  alias MusicQuiz.Question

  @valid_attrs %{content: "which band released the album 'Yellow Submarine?'"}
  @invalid_attrs %{}

  test "valid with good attributes" do
    changeset = Question.changeset(%Question{}, @valid_attrs)
    assert changeset.valid?
  end

  test "invalid with empty attributes" do
    changeset = Question.changeset(%Question{}, @invalid_attrs)
    refute changeset.valid?
  end
end
