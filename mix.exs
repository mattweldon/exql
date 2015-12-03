defmodule Exql.Mixfile do
  use Mix.Project

  @version "0.0.3"

  def project do
    [app: :exql,
     version: @version,
     elixir: "~> 1.1",
     description: description,
     package: package,
     docs: [source_ref: "v#{@version}",
            main: Exql.Query,
            source_url: "https://github.com/mattweldon/exql",
            extras: ["README.md"]],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :tds]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:tds, "~> 0.5.1"},
    {:earmark, "~> 0.1", only: :dev},
    {:ex_doc, "~> 0.10", only: :dev}]
  end

  defp description do
    """
    A functional query tool for MSSQL.
    """
  end

  defp package do
    [maintainers: ["Matt Weldon"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/mattweldon/exql"}]
  end
end
