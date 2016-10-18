defmodule MusicQuiz.GenreControllerTest do
  use MusicQuiz.ConnCase

  test "GETs index as root path" do
    conn = get build_conn(), "/"
    assert conn.resp_body =~ "Genres"
  end
end
