defmodule Bmark.Server do
  use GenServer

  defmodule BmarkEntry do
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
      Stream.repeatedly(fn -> time(entry) end) |> Stream.take(entry.runs) |> Enum.to_list
    }
  end

  defp time(entry) do
    {time, _value} = :timer.tc(entry.module, entry.name, [])
    time
  end

  def start do
    {:ok, _pid} = GenServer.start_link(__MODULE__, [], name: :Bmark)
  end

  def add(module, name, runs) do
    GenServer.cast(:Bmark, {:add, %{module: module, name: name, runs: runs}})
  end

  def run_benchmarks do
    GenServer.call(:Bmark, :run, :infinity)
  end
end
