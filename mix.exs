defmodule CowinNotifier.MixProject do
  use Mix.Project

  def project do
    [
      app: :cowin_notifier,
      version: "0.1.0",
      elixir: "~> 1.11",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :plug_cowboy],
      mod: {CowinNotifier.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:tesla, "~> 1.4.0"},
      {:hackney, "~> 1.17.0"},
      {:jason, ">= 1.0.0"},
      {:timex, "~> 3.0"},
      {:distillery, "~> 2.1"}
    ]
  end
end
