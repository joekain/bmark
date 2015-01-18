defmodule Example do
  use Bmark

  bmark :runner do
    IO.puts ":runner test is running"
  end
end