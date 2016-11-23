Application.ensure_all_started(:hound)
ExUnit.start

Ecto.Adapters.SQL.Sandbox.mode(MusicQuiz.Repo, :manual)
{:ok, _} = Application.ensure_all_started(:ex_machina)
