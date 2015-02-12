defmodule Example do
  use Bmark

  bmark :runner do
    IO.puts ":runner test is running"
  end

  @runs 5
  bmark :count do
    IO.puts ":count test running 5 times"
  end

  bmark :after_count do
    IO.puts ":after_count test running"
  end
end