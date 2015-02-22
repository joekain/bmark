defmodule Bmark.Mixfile do
  use Mix.Project

  def project do
    [app: :bmark,
     version: "1.0.0",
     elixir: "~> 1.0.0",
     deps: deps,
     description: description,
     package: package]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:inch_ex, only: :docs}]
  end

  defp description do
    """
    A benchmarking tool for Elixr with a focus on comparing results with confidence.
    """
  end

  defp package do
    [files: ["lib", "mix.exs", "README.md", "LICENSE", "CONTRIBUTING.md"],
     contributors: ["Joseph Kain"],
     licenses: ["MIT"],
     links: %{
       "github" => "https://github.com/joekain/bmark",
       "Blog posts" => "http://learningelixir.joekain.com/bmark-posts/"
     }]
  end
end
