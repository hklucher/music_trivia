defmodule MusicQuiz.User do
  use MusicQuiz.Web, :model
  alias MusicQuiz.{Repo, User}

  schema "users" do
    field :email, :string
    field :crypted_password, :string
    field :password, :string, virtual: true

    has_many :completed_quizzes, MusicQuiz.CompletedQuiz

    timestamps
  end

  def quizzes(id) do
    user = Repo.get(User, id) |> Repo.preload(:completed_quizzes)
    user.completed_quizzes
  end

  @required_fields ~w(email password)

  # TODO: add actual regex to check for valid email address
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> validate_required([:email, :password])
  end
end
