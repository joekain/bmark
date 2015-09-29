defmodule Bmark.Server do
  use GenServer

  @moduledoc """
  The Bmark server maintains a list of benchmarks registered with the `bmark` module.  It
  can also run all benchmarks in the list.
  """

  defmodule BmarkEntry do
    @moduledoc """
    BmarkEntry holds a single benchmark entry for the list.
    * `module`  - The module that contains the bmark function.
    * `name`    - The benchmark name (also the name of the underlying function)
    * `runs`    - The number of times to run the benchmark.
    """
    defstruct module: :none, name: :none, runs: :none
  end

  def handle_cast({:add, entry}, state) do
    {:noreply, [entry | state]}
  end

  def handle_call(:run, _from, state) do
    {:reply, Enum.map(state, &collect_single_benchmark/1), state}
  end

  defp collect_single_benchmark(entry) do
    {
      entry.module,
      entry.name,
      Stream.repeatedly(fn -> prepare_and_time(entry) end) |> Stream.take(entry.runs)
    }
  end

  defp prepare_and_time(entry) do
    :erlang.garbage_collect
    time(entry)
  end

  defp time(entry) do
    {time, _value} = :timer.tc(entry.module, entry.name, [])
    time
  end

  @doc """
  Start the Bmark server.
  """
  def start do
    {:ok, _pid} = GenServer.start_link(__MODULE__, [], name: :Bmark)
  end

  @doc """
  Add a new benchmark to the list.

  `module`  - The module that contains the bmark function.
  `name`    - The benchmark name (also the name of the underlying function)
  `runs`    - The number of times to run the benchmark.
  """
  def add(module, name, runs) do
    GenServer.cast(:Bmark, {:add, %{module: module, name: name, runs: runs}})
  end

  @doc """
  Run all the benchmarks and write results.
  """
  def run_benchmarks do
    GenServer.call(:Bmark, :run, :infinity)
  end
end
