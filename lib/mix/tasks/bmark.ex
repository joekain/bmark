defmodule Mix.Tasks.Bmark do
  use Mix.Task
  
  @shortdoc "Run bmark benchmark functions"
  
  @moduledoc """
   ## Usage
       mix bmark
       
   Runs all benchmarks matching the pattern bmark/*_bmark.ex.  Results of the tests will
   be written to results/<benchmark name>.results.
   """
  
  def run(_args) do
    setup_project
    start_server
    setup_bmark_files
    setup_exit_handler
  end

  defp setup_project do
    Mix.Project.get!
    Mix.Task.run("compile", [])
    Mix.Task.run("loadpaths", [])
  end

  defp setup_bmark_files do
    Path.wildcard("bmark/**/*_bmark.ex") |> Kernel.ParallelRequire.files()
  end

  defp start_server do
    Bmark.Server.start
  end

  defp setup_exit_handler do
    System.at_exit(fn
      0 -> Bmark.Server.run_benchmarks |> report
      error_status -> error_status
    end)
  end

  defp report(results) do
    Enum.map(results, &report_single_bmark(&1))
  end

  defp report_single_bmark({module, name, list_of_times}) do
    filename = report_file_name(module, name)
    File.open(filename, [:write], fn(file) ->
      report_single_time(list_of_times, file)
    end)
  end

  defp report_file_name(module, name), do: "results/#{simplify_module_name(module)}.#{name}.results"

  defp report_single_time(list_of_times, file), do: Enum.map(list_of_times, &IO.puts(file, &1))

  defp simplify_module_name(module) do
    strip_elixir_from_module_name(module) |> String.downcase
  end

  defp strip_elixir_from_module_name(module) do
    ["Elixir", mod] = Atom.to_string(module) |> String.split(".", parts: 2)
    mod
  end
end
