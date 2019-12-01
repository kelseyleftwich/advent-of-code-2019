defmodule Advent.Day1Test do
  use ExUnit.Case

  describe "Day 1: Fuel Counter Upper" do
    test "calculate_fuel/1 Integer" do
      assert 2 = Advent.Day1.calculate_fuel(12)

      assert 2 = Advent.Day1.calculate_fuel(14)

      assert 654 = Advent.Day1.calculate_fuel(1969)

      assert 33583 = Advent.Day1.calculate_fuel(100756)
    end

    test "calculate_fuel/1 list" do
      masses = [12, 14, 1969, 100756]

      assert 34241 = Advent.Day1.calculate_fuel(masses)
    end


  end
end
