defmodule Example do
  use Bmark

  bmark :runner do
    IO.puts ":runner test is running"
  end

  bmark :count, runs: 5 do
    IO.puts ":count test running 5 times"
  end
end