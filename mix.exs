defmodule Tunedrop.Mixfile do
  use Mix.Project

  def project do
    [
      app: :tunedrop,
      version: "0.0.1",
      elixir: "~> 1.0",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      aliases: aliases,
      deps: deps,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        "coveralls": :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Tunedrop, []},
      applications: [
        :phoenix, :phoenix_html, :cowboy, :logger, :gettext, :phoenix_ecto,
        :postgrex, :comeonin, :timex, :httpotion, :time_ago_words
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.1.4"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_ecto, "~> 2.0"},
      {:phoenix_html, "~> 2.4"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.9"},
      {:cowboy, "~> 1.0"},
      {:cors_plug, "~> 1.1"},
      {:secure_random, "~> 0.2"},
      {:timex, "~> 2.1"},
      {:timex_ecto, "~> 1.0.4"},
      {:time_ago_words, "~> 0.0.1"},
      {:phoenix_haml, "~> 0.2.1"},
      {:httpotion, "~> 2.2.0"},
      {:floki, "~> 0.8"},
      {:comeonin, "~> 2.0"},
      {:excoveralls, "~> 0.5", only: :test}
   ]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"]
    ]
  end
end
