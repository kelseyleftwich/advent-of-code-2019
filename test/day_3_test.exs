defmodule Advent.Day3Test do
  use ExUnit.Case

  alias Advent.Day3

  describe "Day 3: Crossed Wires" do
    test "closest_intersection_distance" do
      assert 6 = Day3.solve_puzzle_1("example_1.txt")
      assert 159 = Day3.solve_puzzle_1("example_2.txt")
      assert 135 = Day3.solve_puzzle_1("example_3.txt")
    end

    test "least amount of steps to intersection" do
      assert 30 = Day3.solve_puzzle_2("example_1.txt")
      assert 610 = Day3.solve_puzzle_2("example_2.txt")
      assert 410 = Day3.solve_puzzle_2("example_3.txt")
    end
  end
end
