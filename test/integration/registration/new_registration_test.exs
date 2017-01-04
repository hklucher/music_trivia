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
    form = find_element(:tag, "form")
    fill_field({:id, "user_email"}, "email@email.com")
    fill_field({:id, "user_password"}, "password")
    submit_element(form)
    assert page_source =~ "What is it?"
  end
end
