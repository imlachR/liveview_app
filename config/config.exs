# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :trivium,
  ecto_repos: [Trivium.Repo]

config :trivium_web,
  ecto_repos: [Trivium.Repo],
  generators: [context_app: :trivium]

# Configures the endpoint
config :trivium_web, TriviumWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "dxUbajgN4RmWVbMubOIkc3hHBO8TFmu3kdY6cIdy/zDrmoym/xpoCx/7f8xXTHmT",
  render_errors: [view: TriviumWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Trivium.PubSub,
  live_view: [signing_salt: "Uu8swEh8"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :trivium, TriviumWeb.Gettext, locales: ~w(en es pt_BR), default_locale: "en"

config :trivium, Trivium.Mailer,
  adapter: Swoosh.Adapters.AmazonSES,
  region: {:system, "SES_REGION"},
  access_key: {:system, "SES_ACCESS_KEY_ID"},
  secret: {:system, "SES_SECRET_ACCESS_KEY"}

# If using S3:
config :ex_aws,
  access_key_id: {:system, "AWS_ACCESS_KEY_ID"},
  secret_access_key: {:system, "AWS_SECRET_ACCESS_KEY"},
  json_codec: Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
