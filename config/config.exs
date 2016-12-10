# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :music_quiz,
  ecto_repos: [MusicQuiz.Repo]

# Configures the endpoint
config :music_quiz, MusicQuiz.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "RpM6pyzMESDePozo8GRqQsaTdkah6bpEw/VjWCvXD2PjyLJfFGqX9PVydqMbxGBx",
  render_errors: [view: MusicQuiz.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MusicQuiz.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures Guardian
config :guardian, Guardian,
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  issuer: "MusicQuiz",
  ttl: { 30, :days},
  verify_issuer: true,
  secret_key: "<your secret guardian key>",
  serializer: MusicQuiz.GuardianSerializer


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
