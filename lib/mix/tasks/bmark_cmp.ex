defmodule Mix.Tasks.Bmark.Cmp do
  use Mix.Task
  
  defmodule Stats do
    defstruct count: 0, mean: 0, stdev: 0
  end

  def run(args) do
    args
    |> parse_args
    |> load_results
    |> compare_results
    |> report_difference
  end

  defp parse_args(args) do
    case OptionParser.parse(args, strict: []) do
      {[], [name1, name2], []} -> [name1, name2]
      {_, _, _}                -> usage
    end
  end

  defp usage do
    Kernel.exit("Usage: mix lifebench.cmp <results file 1> <results file 2>")
  end

  defp load_results(array_of_filenames) do
    Enum.map(array_of_filenames, &load_single_result_file/1)
  end

  defp load_single_result_file(filename) do
    File.stream!(filename)
  end
  
  defp compare_results(array_of_results) do
    array_of_results
    |> Enum.map(&convert_to_integer(&1))
    |> Enum.map(&compute_stats(&1))
    |> compute_t_value
  end
  
  defp convert_to_integer(results) do
    results
    |> Enum.map(&String.strip(&1))
    |> Enum.map(&String.to_integer(&1))
  end

  defp compute_stats(results) do
    %Stats
    {
      count: Enum.count(results),
      mean:  sample_mean(results),
      stdev: corrected_sample_stdev(results)
    }
  end

  defp sample_mean(samples) do
    Enum.sum(samples) / Enum.count(samples)
  end

  defp corrected_sample_stdev(samples) do
    mean = sample_mean(samples)
    (Enum.map(samples, fn(x) -> (mean - x) * (mean - x) end) |> Enum.sum) / (Enum.count(samples) - 1)
    |> :math.sqrt
  end

  defp compute_t_value(stats) do
    a = compute_a(stats)
    b = compute_b(stats)
    t = compute_t(a, b, stats)
    {stats, t}
  end

  defp compute_a([%Stats{count: n1}, %Stats{count: n2}]) do
    (n1 + n2) / (n1 * n2)
  end

  defp compute_b([%Stats{count: n1, stdev: s1}, %Stats{count: n2, stdev: s2}]) do
    ( ((n1 - 1) * s1 * s1) + ((n2 - 1) * s2 * s2) ) / (n1 + n2 - 2)
  end

  defp compute_t(a, b, [%Stats{mean: u1}, %Stats{mean: u2}]) do
    abs(u1 - u2) / :math.sqrt(a * b)
  end

  defp report_difference({[%Stats{mean: u1}, %Stats{mean: u2}] = stats, t}) do
    IO.puts "#{u1} -> #{u2} (#{percent_increase(u1, u2)}) with p < #{t_dist(t, df(stats))}"
    IO.puts "t = #{t}, #{df(stats)} degrees of freedom"
  end

  defp df([%Stats{count: n1}, %Stats{count: n2}]) do
    n1 + n2 - 2
  end

  def percent_increase(u1, u2) do
    percent = 100 * (u2 - u1) / u1
    percent_s = Float.to_string(percent, [decimals: 2])
    cond do
      percent < 0 ->  "#{percent_s}%"
      true        -> "+#{percent_s}%"
    end
  end

  defp t_dist(t, df) do
    Bmark.Distribution.t(t, df)
  end
end
