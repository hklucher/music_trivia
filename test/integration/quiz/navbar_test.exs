defmodule MusicQuiz.NavbarTest do
  use Hound.Helpers
  use MusicQuiz.ConnCase

  import MusicQuiz.Factory
  import MusicQuiz.TestHelpers

  hound_session

  test "has a link to sign up when not logged in" do
    navigate_to("/")
    refute find_element(:link_text, "Sign Up") == nil
  end

  test "does not link to sign up when logged in" do
    user = insert(:user)
    login(user)
    assert {:error, _} = search_element(:link_text, "Sign Up", 1)
  end
end
