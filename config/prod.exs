import Config

# Configures Swoosh API Client
config :swoosh, api_client: Swoosh.ApiClient.Finch, finch_name: LabsEasy.Finch

# Disable Swoosh Local Memory Storage
config :swoosh, local: false

# Do not print debug messages in production
config :logger, level: :info

config :labs_easy, LabsEasy.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "labs_easy",
  stacktrace: true,
  pool_size: 10

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.
