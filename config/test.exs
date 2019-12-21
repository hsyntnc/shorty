use Mix.Config

database_url = System.get_env("DATABASE_URL") || "postgres://postgres:postgres@localhost:5432/shorty_test"

# Configure your database
config :shorty, Shorty.Repo,
  url: database_url,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :shorty, ShortyWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
