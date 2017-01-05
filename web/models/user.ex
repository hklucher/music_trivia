defmodule MusicQuiz.User do
  @moduledoc """
  Represents a user. Has many completed quizzes.
  """

  @valid_email_regex ~r/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  use MusicQuiz.Web, :model
  use Timex.Ecto.Timestamps

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

  def join_date(id) do
    user = Repo.get!(User, id)
    {:ok, date} = Timex.format(user.inserted_at, "{0M}/{D}/{YYYY}")
    date
  end

  @required_fields ~w(email password)

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password])
    |> unique_constraint(:email)
    |> validate_format(:email, @valid_email_regex)
    |> validate_length(:password, min: 8)
    |> validate_required([:email, :password])
  end
end
