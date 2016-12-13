Application.ensure_all_started(:hound)
ExUnit.start

Ecto.Adapters.SQL.Sandbox.mode(MusicQuiz.Repo, :manual)
{:ok, _} = Application.ensure_all_started(:ex_machina)

defmodule MusicQuiz.TestHelpers do
  use Hound.Helpers
  use MusicQuiz.ConnCase

  hound_session

  def login(user) do
    navigate_to("/sessions/new")
    form = find_element(:tag, "form")
    email_field = find_element(:id, "session_email")
    password_field = find_element(:id, "session_password")
    fill_field(email_field, user.email)
    fill_field(password_field, user.password)
    submit_element(form)
  end
end
