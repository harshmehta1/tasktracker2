use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :tasktracker, TasktrackerWeb.Endpoint,
  secret_key_base: "W1U3sTp1raz3IIvcT7kItipFrGcFH1cDUYedwKXy1Y8XcewU8BJASsO5HNHH7vu4"

# Configure your database
config :tasktracker, Tasktracker.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "tasktracker",
  password: "watermelon",
  database: "tasktracker_prod",
  pool_size: 15
