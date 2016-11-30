defmodule MusicQuiz.SessionControllerTest do
  use MusicQuiz.ConnCase
  import MusicQuiz.Factory

  test "get login is successful" do
    response = build_conn(:get, "/login") |> send_request
    assert response.status == 200
  end

  test "a successful POST redirects to root path" do
    user = insert(:user)
    conn = post build_conn(), "/login", %{"session" => %{"email" => user.email, "password" => user.password}} 
    assert redirected_to(conn) == "/"
  end

  test "a bad login attempt re renders the page with error" do
    conn = post build_conn(), "/login", %{"session" => %{"email" => "wrong", "password" => "wronger"}}
    assert conn.resp_body =~ "Wrong email or password"
  end

  defp send_request(conn) do
    conn
    |> put_private(:plug_skip_csrf_protection, true)
    |> MusicQuiz.Endpoint.call([])
  end
end
