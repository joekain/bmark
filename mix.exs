defmodule Bmark.Mixfile do
  use Mix.Project

  def project do
    [app: :bmark,
     version: "1.0.2",
     elixir: "~> 1.0",
     deps: deps,
     description: description,
     package: package]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:inch_ex, only: :docs},
      {:earmark, "~> 0.1.17", only: :dev},
      {:ex_doc, "~> 0.10", only: :dev}
    ]
  end

  defp description do
    """
    A benchmarking tool for Elixir with a focus on comparing results with confidence.
    """
  end

  defp package do
    [files: ["lib", "mix.exs", "README.md", "LICENSE", "CONTRIBUTING.md"],
     maintainers: ["Joseph Kain"],
     licenses: ["MIT"],
     links: %{
       "github" => "https://github.com/joekain/bmark",
       "Blog posts" => "http://learningelixir.joekain.com/bmark-posts/"
     }]
  end
end
