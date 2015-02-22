defmodule Mix.Tasks.Bmark.Cmp do
  use Mix.Task

  @shortdoc "Compare bmark results"
  
  @moduledoc """
   ## Usage
       mix bmark.cmp <result1> <result2>
       
   Compares a pair of benchmark results.  
   
   <result1> and <result2> should be results files written by bmark for different runs of
   the same benchmark.  bmark.cmp will compare the two results and will report the statistical
   significance of the difference in their means.
   """
  
  defmodule Stats do
    @moduledoc """
    Stores statistics from a bmark result file
    * `count`    - The number of runs in the results file.
    * `mean`     - The arithmetic mean of the results from the file
    * `stdev`    - The standard deviation of the results from the file
    """
    defstruct count: 0, mean: 0, stdev: 0
  end

  @doc """
  The task run function processes the arguments into a report.
  """
  def run(args) do
    args
    |> parse_args
    |> load_results
    |> report_results
    |> compare_results
    |> report_difference
  end

  # Extracts eactly two files names from `args` or prints the usage and exits.
  defp parse_args(args) do
    case OptionParser.parse(args, strict: []) do
      {[], [name1, name2], []} -> [name1, name2]
      {_, _, _}                -> usage
    end
  end

  defp usage do
    Kernel.exit("Usage: mix lifebench.cmp <results file 1> <results file 2>")
  end

  defp load_results(list_of_filenames) do
    {
      list_of_filenames |> Enum.map(&filename_path_to_header/1),
      Enum.map(list_of_filenames, &load_single_result_file/1)
    }
  end
  
  # Trims current working directory from the filename to produce a shorter string to be used as a
  # column header for the report.
  defp filename_path_to_header(filename) do
    Path.relative_to_cwd(filename)
  end

  defp load_single_result_file(filename) do
    File.stream!(filename)
    |> Enum.map(&String.strip(&1))
  end
  
  defp report_results({list_of_headers, list_of_results}) do
    Bmark.ComparisonFormatter.format(list_of_headers, list_of_results) |> IO.puts
    list_of_results
  end

  defp compare_results(list_of_results) do
    list_of_results
    |> Enum.map(&convert_to_integer(&1))
    |> Enum.map(&compute_stats(&1))
    |> compute_t_value
  end
  
  defp convert_to_integer(results) do
    results
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

  defp percent_increase(u1, u2) do
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
