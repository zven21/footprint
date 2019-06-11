use Mix.Config

config :logger, :console, level: :error

config :footprint, ecto_repos: [Dummy.Repo]

import_config "#{Mix.env()}.exs"
