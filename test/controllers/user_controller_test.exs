defmodule MusicQuiz.UserControllerTest do
  use MusicQuiz.ConnCase
  import MusicQuiz.Factory

  test "GET show redirects when not logged in" do
    user = insert(:user)
    conn = build_conn(:get, "users/#{user.id}") |> send_request
    assert html_response(conn, 302)
  end

  defp send_request(conn) do
    conn
    |> put_private(:plug_skip_csrf_protection, true)
    |> MusicQuiz.Endpoint.call([])
  end
end
