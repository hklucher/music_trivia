defmodule MusicQuiz.NavbarTest do
  use MusicQuiz.ConnCase
  use Hound.Helpers

  import MusicQuiz.Factory
  import MusicQuiz.TestHelpers

  hound_session

  test "has a link to sign up when not logged in" do
    navigate_to("/")
    assert find_element(:link_text, "Sign Up")
  end

  test "does not link to sign up when logged in" do
    user = insert(:user)
    login(user)
    assert {:error, _} = search_element(:link_text, "Sign Up", 0)
  end

  test "has a link to sign out when logged in" do
    user = insert(:user)
    login(user)
    assert {:ok, _} = search_element(:link_text, "Log Out", 0)
  end

  test "has a link to log in when not logged in" do
    navigate_to("/")
    assert {:ok, _} = search_element(:link_text, "Log In", 0)
  end

  test "has a link to a users profile when logged in" do
    user = insert(:user)
    login(user)
    assert {:ok, _} = search_element(:link_text, "Your Profile", 0)
  end

  test "does not have a link to a users profile when not logged in" do
    navigate_to("/")
    assert {:error, _} = search_element(:link_text, "Your Profile", 0)
  end
end
