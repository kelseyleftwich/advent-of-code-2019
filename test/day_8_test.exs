defmodule Advent.Day8Test do
  use ExUnit.Case

  describe "Day 8" do
    test "get_layers/3" do
      assert [[1, 2, 3, 4, 5, 6], [7, 8, 9, 0, 1, 2]] = Advent.Day8.get_layers(123456789012,2, 3)

      assert [1, 2, 3, 4, 5, 6] = Advent.Day8.fewest_zeros_layer(123456789012,2, 3)

      assert 1 = Advent.Day8.solve("example.txt", 2, 3)
    end
  end
end
