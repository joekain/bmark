defmodule Mix.Tasks.Bmark do
  use Mix.Task
  
  def run(_args) do
    setup_project
    setup_bmark_files

    File.open("results/example.runner.results", [:write], fn(file) ->
      IO.puts(file, "Some results")
    end)
  end

  defp setup_project do
    Mix.Project.get!
    Mix.Task.run("compile", [])
    Mix.Task.run("loadpaths", [])
  end

  defp setup_bmark_files do
    Path.wildcard("bmark/**/*_bmark.ex") |> Kernel.ParallelRequire.files()
  end
end
