defmodule Footprint.MixProject do
  use Mix.Project

  @version "0.3.0"
  @github "https://github.com/zven21/footprint"

  def project do
    [
      app: :footprint,
      version: @version,
      description: "Track changes to your database with Ecto.",
      elixir: "~> 1.8",
      package: package(),
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0", only: :test},
      {:ex_machina, "~> 2.2", only: :test}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md"],
      maintainers: ["zven21"],
      licenses: ["MIT"],
      links: %{"GitHub" => @github}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "priv", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp aliases do
    [
      test: [
        "ecto.drop --quiet",
        "ecto.create --quiet",
        "ecto.migrate --quiet",
        "test"
      ]
    ]
  end
end
