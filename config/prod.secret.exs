use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or you later on).
config :music_quiz, MusicQuiz.Endpoint,
  secret_key_base: System.get_env("SECRET_KEY_BASE")
  # secret_key_base: "C/qfYtpIaFwsyXxfxal1n1w7kyoGNHoBbwBchkhfykIGSIeGL/h0qj+jaNO2yEyf"

# Configure your database
config :music_quiz, MusicQuiz.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DATABASE_USERNAME"),
  password: System.get_env("DATABASE_PASSWORD")
  # username: "postgres",
  # password: "postgres",
  database: "music_quiz_prod",
  pool_size: 20

config :music_quiz,
  spotify_client_id: "ccbf2cf9496844b48eaa89100cb97968",
  spotify_client_secret: "cda951c9804b4a27bdf9ce4509a48268"
