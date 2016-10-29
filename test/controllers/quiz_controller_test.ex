defmodule MusicQuiz.QuizControllerTest do
  use MusicQuiz.ConnCase
  alias MusicQuiz.Repo
  alias MusicQuiz.Genre
  alias MusicQuiz.Quiz


  test "lists all quizzes for a given genre" do
    changeset = Genre.changeset(%Genre{}, %{name: "classic rock"})
    Repo.insert(changeset)
    response = build_conn(:get, "genres/#{1}/quizzes") |> send_request
    assert response.status == 200
  end

  defp send_request(conn) do
    conn
    |> put_private(:plug_skip_csrf_protection, true)
    |> MusicQuiz.Endpoint.call([])
  end
end
