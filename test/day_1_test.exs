defmodule Advent.Day1Test do
  use ExUnit.Case
  doctest Advent.Day1

  describe "Day 1: Fuel Counter Upper" do
    test "calculate_fuel/1 Integer" do
      assert 2 = Advent.Day1.calculate_fuel(12)

      assert 2 = Advent.Day1.calculate_fuel(14)

      assert 966 = Advent.Day1.calculate_fuel(1969)

      assert 50346 = Advent.Day1.calculate_fuel(100756)
    end

    test "calculate_fuel/1 with zero and negative input" do
      assert 0 = Advent.Day1.calculate_fuel(0)
      assert 0 = Advent.Day1.calculate_fuel(-1)
      assert 0 = Advent.Day1.calculate_fuel(-947)
    end

    test "calculate_fuel/1 list" do
      masses = [12, 14, 1969, 100756]

      assert 51316 = Advent.Day1.calculate_fuel(masses)
    end


  end
end
