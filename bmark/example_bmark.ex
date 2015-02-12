defmodule Example do
  use Bmark

  bmark :runner do
    IO.puts ":runner test is running"
  end

  @runs 5
  bmark :count do
    IO.puts ":count test running 5 times"
  end
end