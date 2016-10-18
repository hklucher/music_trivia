defmodule MusicQuiz.Genre do
  use MusicQuiz.Web, :model

  schema "genres" do
    field :name, :string

    timestamps
  end

  @required_fields ~w(name)

  def changeset(genre, params \\ %{}) do
    genre
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
