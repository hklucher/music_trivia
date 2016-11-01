defmodule MusicQuiz.QuestionController do
  use MusicQuiz.Web, :controller

  def show(conn, %{"genre_id" => genre_id, "id" => question_id}) do
    render conn, "show.html"
  end
end
