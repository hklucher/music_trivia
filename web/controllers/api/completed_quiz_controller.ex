defmodule MusicQuiz.Api.CompletedQuizController do
  use MusicQuiz.Web, :controller
  alias MusicQuiz.{CompletedQuiz, Repo, User}

  def create(conn, %{"user_id" => user_id, "completed_quiz" => completed_quiz}) do
    user = Repo.get(User, user_id)
    changeset = CompletedQuiz.changeset(%CompletedQuiz{}, completed_quiz)
    case Repo.insert(changeset) do
      {:ok, quiz} ->
        new_quiz =
          quiz
          |> Repo.preload(:user)
          |> Ecto.Changeset.change
          |> Ecto.Changeset.put_assoc(:user, user)
          |> Repo.update
        render conn, "show.json", %{completed_quiz: new_quiz}
      {:error, changeset} ->
        render conn, "show.json", %{error: changeset.errors}
    end
  end
end
