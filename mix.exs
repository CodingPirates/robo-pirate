defmodule RoboPirate.MixProject do
  use Mix.Project

  def project do
    [
      app: :robo_pirate,
      version: "0.1.0",
      elixir: "~> 1.8",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      deps: deps()
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/mock_server"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {RoboPirate, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:poison, "~> 4.0"},
      {:httpoison, "~> 1.5"},
      {:excoveralls, ">= 0.0.0", only: :test},
      {:faker, ">= 0.0.0", only: :test},
      {:credo, "~> 1.1.5", only: [:dev, :test], runtime: false},
      {:junit_formatter, ">= 0.0.0", only: :test}
    ]
  end
end
