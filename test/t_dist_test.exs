defmodule Bmark.Distribution.Test do
  use ExUnit.Case

  test "it indexes by degrees of freedom" do
    assert Bmark.Distribution.t(6.313753, 1) == 0.05
  end
  
  test "it should support many degrees of freedom" do
    assert Bmark.Distribution.t(6.313753, 1_000_000) <= 1.0
  end
end
