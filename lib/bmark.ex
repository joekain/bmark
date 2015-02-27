defmodule Bmark do
  @moduledoc """
  A benchmarking tool for Elixir
  
  ## Example
  
      # File: bmark/example_bmark.ex
      
      # Create a module and use `Bmark`.
      defmodule Example do
        use Bmark
      
        bmark :runner do
          IO.puts ":runner test is running"
        end
      
        bmark :benchmark_with_runs, runs: 5 do
          IO.puts "test running 5 times"
        end
      end
  
  To run the benchmarks above run
  
      mix bmark
    
  which will write results to results/example.runner.results and
  results/example.benchmark_with_runs.results.
  
  ## Comparing Results
  
  Given two results files you can compare the results using
  
      mix bmark.cmp results/RunA.results results/RunB.results
  """
  
  @doc false
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__), only: :macros
    end
  end

  @doc """
  Define a benchmark with an atom and an optional number of runs.
  
  This macro allows a benchmark to be defined with a given name.  
  
  ## Examples
  
      bmark :runner do
        IO.puts ":runner test is running"
      end
  
  By default a benchmark with run 10 times. But a benchmark can specify and optional number of
  runs by using the runs: option as in this example:
  
      bmark :benchmark_with_runs, runs: 5 do
        IO.puts "test running 5 times"
      end
  
  This example will run the benchmark only 5 times.
  """
  defmacro bmark(name, options \\ [runs: 20], [do: body]) do
    runs = Keyword.get(options, :runs)
    quote bind_quoted: binding do
      Bmark.Server.add(__ENV__.module, name, runs)
      def unquote(name)(), do: unquote(body)
    end
  end
end
