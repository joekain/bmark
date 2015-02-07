defmodule Bmark.ComparisonFormatterTest do
  use ExUnit.Case
  
  alias Bmark.ComparisonFormatter

  test "it should format the headers" do
    headers = ["left", "right"]    
    results = [ [], [] ]
    
    assert ComparisonFormatter.format(headers, results) == """
    left:  right:
    """
  end

  test "it should format results" do
    headers = ["left", "right"]
    results = [ ["1", "2"],  ["3", "4"] ]

    assert ComparisonFormatter.format(headers, results) ==
    """
    left:  right:
    1      3
    2      4
    """
  end

  test "it formats lists of different sizes" do
    headers = ["left", "right"]
    results = [ ["1", "2"],  ["3", "4", 5] ]

    assert ComparisonFormatter.format(headers, results) ==
    """
    left:  right:
    1      3
    2      4
           5
    """
  end
  
  test "it formats when first list is longer" do
    headers = ["left", "right"]
    results = [ ["1", "2", "5"],  ["3", "4"] ]

    assert ComparisonFormatter.format(headers, results) ==
    """
    left:  right:
    1      3
    2      4
    5      
    """
  end
end
