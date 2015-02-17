# Bmark

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
