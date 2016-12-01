require IEx
defmodule MusicQuiz.Api.CompletedQuizController do
  use MusicQuiz.Web, :controller
  alias MusicQuiz.Repo
  alias MusicQuiz.CompletedQuiz

  def create(conn, %{"completed_quiz" => params}) do
    # completed_quiz_params = Map.put(params, :user_id, current_user.id)
    IEx.pry
    case Repo.insert(CompletedQuiz.changeset(%CompletedQuiz{}, params)) do
      {:ok, changeset} ->
        render "create.json", changeset
      {:error, _} ->
        render "create.json", %{"error" => "something went wrong"}
    end
  end
end
