# Bmark

[![Build Status](https://travis-ci.org/joekain/bmark.svg?branch=master)](https://travis-ci.org/joekain/bmark)

Bmark is a benchmarking tool for Elixir.  It allows easy creation of benchmarks of Elixir functions.  It also supports comparing sets of benchmarking results.

Comparing benchmarking results is a topic that I have struggled with for years.  I run a benchmark several times and get varying results.  Then, I make a change to my program and I want to decide if the change causes an improvement in the benchmark score.  I rerun the benchmark several times and again get varying results.  How do I compare these results?  I can compare average score, but is that accurate?  How do I tell if the mean of the second run is large enough to be meaningful?  How do I know if it is "in the noise?"

Bmark answers this questions using statistical hytpotesis testing.  Given two sets of benchmark runs, bmark can show:

    RunA:                                 RunB:
    24274268                              6426990
    24563751                              6416149
    24492221                              6507946
    24516553                              6453309
    24335224                              6491314
    24158102                              6405073
    24357174                              6504260
    24213098                              6449789
    24466586                              6532929
    24289248                              6509800
    
    24366622.5 -> 6469755.9 (-73.45%) with p < 0.0005
    t = 391.56626146910503, 18 degrees of freedom

This shows that RunA ran in an average of 24366622.5 ms and RunB ran in an average of 6469755.9 ms and that the runtime improved by 73.45% which is statistically meaningful with a confidence level of 99.95%.

## Usage

### Writing Benchmarks

To create a benchmark withing bmark write a module and use the `bmark` function to create a file ending in `_bmark.exs`.  Put the file in a directory called `bmark`.  Alltogether, that should look like this

    Project Root
    +-- bmark
    |   +-- example_bmark.exs
    +-- lib
    |   +-- your_project_files
    +-- mix.exs

In `example_bmark.exs` you should include a module and benchmark function created by using `bmark` 
like this:

```elixir
defmodule Example do
  use Bmark

  bmark :runner do
    IO.puts ":runner test is running"
  end
  
  bmark :benchmark_with_runs, runs: 5 do
    IO.puts "test running 5 times"
  end
end
```

The `:runner` benchmark will be run 10 times, the default number of runs.  `:benchmark_with_runs` specifies the `:runs` option and will be run only 5 times.

### Running Benchmarks

To run all benchmarks run:

    $ mix bmark

This will produce the files

    Project Root
    +-- results
    |   +-- example.runner.results
    |   +-- example.benchmark_with_runs.results
    
which will contain the run times, in miliseconds, for each run of the benchmark.

### Comparing Benchmark Results

If you have two results files you can compare them by running

    $ mix bmark.cmp results/RunA.results results/RunB.results
    
and bmark will print out the comparison.  Here's an example of the comparison with explantions for each section:

    RunA:                                 RunB:
    24274268                              6426990
    24563751                              6416149
    24492221                              6507946
    24516553                              6453309
    24335224                              6491314
    24158102                              6405073
    24357174                              6504260
    24213098                              6449789
    24466586                              6532929
    24289248                              6509800
    
The section above contains the raw result data presented side-by-side.  This is the same data your would get by looking at RunA.results and RunB.results.

    24366622.5 -> 6469755.9 (-73.45%) with p < 0.0005

This line shows the change in mean (average) between the two runs. Next, it shows the percentage change and finally confidence value.  You can interpret this as saying there is `1 - p`, or a greater than 99.95% confidence that the change in means is statistically significant.  That is, the smaller the value of `p` the more confident you can be in the change in performance.

    t = 391.56626146910503, 18 degrees of freedom

The final line shows the `t` value and degrees of freedom.  This is the raw statistical data used to compute the confidence value.

## Contributing

See [Contributing](CONTRIBUTING.md)
