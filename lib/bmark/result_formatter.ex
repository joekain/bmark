defmodule Bmark.ResultFormatter do
  def format([left, right], [lresults, rresults]) do
    initial = "#{left}  #{right}\n"
    align = String.length(left)
    zip_filling_in_blanks_for_shorter_list(lresults, rresults)
    |> List.foldl(initial, fn (elem, acc) -> acc <> format_pair(elem, align) end)
  end
  
  defp format_pair({x, y}, align) do
    "#{String.ljust(x, align)}  #{y}\n"
  end
  
  defp zip_filling_in_blanks_for_shorter_list([], []), do: []
  defp zip_filling_in_blanks_for_shorter_list([], [right | right_tail]) do
    [{"", right} | zip_filling_in_blanks_for_shorter_list([], right_tail)]
  end
  defp zip_filling_in_blanks_for_shorter_list([left | left_tail], []) do
    [{left, ""} | zip_filling_in_blanks_for_shorter_list(left_tail, [])]
  end
  defp zip_filling_in_blanks_for_shorter_list([left | left_tail], [right | right_tail]) do
    [{left, right} | zip_filling_in_blanks_for_shorter_list(left_tail, right_tail)]
  end
  
end