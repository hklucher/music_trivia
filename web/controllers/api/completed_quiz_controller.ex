defmodule MusicQuiz.Api.CompletedQuizController do
  use MusicQuiz.Web, :controller
  alias MusicQuiz.{CompletedQuiz, Repo, User}

  def create(conn, %{"user_id" => user_id, "completed_quiz" => completed_quiz_params}) do
    user = Repo.get(User, user_id)
    parsed_params = for {k, v} <- completed_quiz_params, into: %{}, do: {String.to_atom(k), v}
    changeset =
      %CompletedQuiz{}
      |> CompletedQuiz.changeset(parsed_params)
      |> Ecto.Changeset.put_assoc(:user, user)
    case Repo.insert(changeset) do
      {:ok, completed_quiz} ->
        render conn, "show.json", %{completed_quiz: completed_quiz}
      {:error, changeset} ->
        conn
        |> put_status(400)
        |> render("show.json", %{error: changeset.errors})
    end
  end
end
