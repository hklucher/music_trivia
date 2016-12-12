defmodule MusicQuiz.Api.CompletedQuizController do
  use MusicQuiz.Web, :controller

  def create(conn, %{"user_id" => user_id, "completed_quiz" => completed_quiz}) do
    # Create a completed quiz for the user!
  end
end
