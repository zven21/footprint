use Mix.Config

config :footprint, repo: Footprint.Repo

config :footprint, Footprint.Repo,
  username: "postgres",
  password: "postgres",
  database: "footprint_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
