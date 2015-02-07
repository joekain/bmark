defmodule Bmark.ComparisonFormatter do
  def format([left, right], [lresults, rresults]) do
    header(left, right) <>
    side_by_side_results(lresults, rresults, alignment(left))      
  end
  
  defp header(left, right), do: "#{left}:  #{right}:\n"
  
  defp alignment(left), do: String.length(left)
  
  defp side_by_side_results(lresults, rresults, align) do
    merge_results_into_pairs(lresults, rresults)
    |> format_pairs(align)
  end
  
  defp merge_results_into_pairs(lresults, rresults), do:
    zip_filling_in_blanks_for_shorter_list(lresults, rresults)
  
  defp format_pairs(lines, align), do:
    List.foldl(lines, "", fn (elem, acc) -> acc <> format_pair(elem, align) end)
  
  defp format_pair({x, y}, align), do:
    "#{String.ljust(x, align + 1)}  #{y}\n"
  
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