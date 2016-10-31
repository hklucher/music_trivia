defmodule MusicQuiz.Answer do
  use MusicQuiz.Web, :model

  schema "answers" do
    field :content, :string

    belongs_to :quiz, MusicQuiz.Quiz

    timestamps
  end

  def changeset(answer, params \\ %{}) do
    answer
    |> cast(params, [:content])
    |> validate_required([:content])
  end
end
