defmodule Bmark.Mixfile do
  use Mix.Project

  def project do
    [app: :bmark,
     version: "1.0.0",
     elixir: "~> 1.0.0",
     deps: deps,
     description: description]
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
end
