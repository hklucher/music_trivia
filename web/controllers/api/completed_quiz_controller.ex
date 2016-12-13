defmodule MusicQuiz.Api.CompletedQuizController do
  use MusicQuiz.Web, :controller
  alias MusicQuiz.{CompletedQuiz, Repo, User}

  def create(conn, %{"user_id" => user_id, "completed_quiz" => completed_quiz_params}) do
    user = Repo.get(User, user_id)
    changeset =
      %CompletedQuiz{}
      |> Ecto.Changeset.change(%{correct: completed_quiz_params["correct"], possible: completed_quiz_params["possible"]})
      |> Ecto.Changeset.put_assoc(:user, user)
    case Repo.insert(changeset) do
      {:ok, completed_quiz} ->
        render conn, "show.json", %{completed_quiz: completed_quiz}
      {:error, changeset} ->
        render conn, "show.json", %{error: changeset.errors}
    end
  end
end
