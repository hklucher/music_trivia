defmodule MusicQuiz.NavbarTest do
  use Hound.Helpers
  use MusicQuiz.ConnCase

  import MusicQuiz.Factory

  hound_session

  test "has a link to sign up when not logged in" do
    navigate_to("/")
    refute find_element(:link_text, "Sign Up") == nil
  end

  test "does not link to sign up when logged in" do
    user = insert(:user)
    navigate_to("/login")
    form = find_element(:tag, "form")
    email_field = find_element(:id, "session_email")
    password_field = find_element(:id, "session_password")
    fill_field(email_field, user.email)
    fill_field(password_field, user.password)
    submit_element(form)
    assert {:error, _} = search_element(:link_text, "Sign Up", 1)
  end
end
