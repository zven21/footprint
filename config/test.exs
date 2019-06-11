use Mix.Config

config :footprint, Dummy.Repo,
  username: "postgres",
  password: "postgres",
  database: "footprint_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
