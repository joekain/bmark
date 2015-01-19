defmodule Mix.Tasks.Bmark do
  use Mix.Task
  
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
    Enum.map(results, &report_single_result(&1))
  end

  defp report_single_result({module, name, list_of_times}) do
    mod = simplify_module_name(module)
    File.open("results/#{mod}.#{name}.results", [:write], fn(file) ->
      Enum.map(list_of_times, &IO.puts(file, &1))
    end)
  end

  defp simplify_module_name(module) do
    ["Elixir", mod] = Atom.to_string(module) |> String.split(".", parts: 2)
    mod |> String.downcase
  end
end
