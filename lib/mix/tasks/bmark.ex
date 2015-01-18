defmodule Mix.Tasks.Bmark do
  use Mix.Task
  
  def run(_args) do
    File.open("results/example.runner.results", [:write], fn(file) ->
      IO.puts(file, "Some results")
    end)
  end
end