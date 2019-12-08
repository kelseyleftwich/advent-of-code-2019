defmodule Advent.Day6Test do
  use ExUnit.Case

  describe "Day 6" do
    test "count all direct and indirect orbits" do
      # assert 42 = Advent.Day6.validate_map("example.txt")
    end

    test "count transfers between you and santa" do
      assert 4 = Advent.Day6.transfers_between_you_and_santa("example_2.txt")
    end
  end
end
