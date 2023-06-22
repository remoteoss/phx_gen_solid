defmodule PhxGenSolid.MixProject do
  use Mix.Project

  @version "0.3.0"

  def project do
    [
      app: :phx_gen_solid,
      version: @version,
      description: "A SOLID generator for Phoenix 1.7 applications",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package()
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
      {:phoenix, "~> 1.7.6"},
      {:phx_new, "~> 1.7.6", only: [:dev, :test]},
      # Docs
      {:ex_doc, "~> 0.29.4", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      main: "overview",
      source_ref: "v#{@version}",
      source_url: "https://github.com/remoteoss/phx_gen_solid",
      assets: "assets",
      extras: extras()
    ]
  end

  defp extras do
    ["guides/overview.md"]
  end

  defp package do
    [
      maintainers: ["Kramer Hampton"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/remoteoss/phx_gen_solid"}
    ]
  end
end
