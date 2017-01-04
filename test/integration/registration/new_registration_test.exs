defmodule MusicQuiz.NewRegistrationTest do
  use Hound.Helpers
  use MusicQuiz.ConnCase

  hound_session

  test "it has a header" do
    navigate_to("/registrations/new")
    assert page_source =~ "Sign Up"
  end

  test "it has a form" do
    navigate_to("/registrations/new")
    assert find_element(:tag, "form")
  end

  test "displays the home page after registering" do
    navigate_to("/registrations/new")
    fill_field({:id, "user_email"}, "email@email.com")
    fill_field({:id, "user_password"}, "password")
    submit_element({:tag, "form"})
    assert page_source =~ "What is it?"
  end

  test "logs the user in after registration" do
    navigate_to("/registrations/new")
    fill_field({:id, "user_email"}, "email@email.com")
    fill_field({:id, "user_password"}, "password")
    submit_element({:tag, "form"})
    assert find_element(:link_text, "Log Out")
    assert find_element(:link_text, "Your Profile")
  end
end
