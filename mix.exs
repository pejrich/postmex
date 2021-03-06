defmodule Postmex.MixProject do
  use Mix.Project

  def project do
    [
      app: :postmex,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
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
      {:plug, "~> 1.7"},
      {:httpoison, "~> 1.4"},
      {:vex, "~> 0.8.0"}
    ]
  end
end
