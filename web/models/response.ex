defmodule MusicQuiz.Response do
  @moduledoc """
  A response is an incorrect answer to a question.
  """
  use MusicQuiz.Web, :model

  schema "responses" do
    field :content, :string

    belongs_to :question, MusicQuiz.Question

    timestamps
  end

  def changeset(response, params \\ %{}) do
    response
    |> cast(params, [:content, :question_id])
    |> validate_required([:content, :question_id])
    |> cast_assoc(:question)
  end
end
