defmodule MusicQuiz.User do
  use MusicQuiz.Web, :model

  schema "users" do
    field :email, :string
    field :crypted_password, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :crypted_password])
    |> validate_required([:email, :crypted_password])
    |> unique_constraint(:email)
  end
end
