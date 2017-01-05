defmodule MusicQuiz.Answer do
  @moduledoc """
  An answer is a CORRECT response to a question.
  """
  use MusicQuiz.Web, :model

  schema "answers" do
    field :content, :string

    # belongs_to :quiz, MusicQuiz.Quiz
    has_one :quiz, MusicQuiz.Quiz

    timestamps
  end

  def changeset(answer, params \\ %{}) do
    answer
    |> cast(params, [:content])
    |> validate_required([:content])
    |> unique_constraint(:content)
  end
end
