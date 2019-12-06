defmodule Advent.Day5Test do
  use ExUnit.Case

  describe "Day 5" do
    test "opcodes 3 and 4" do
      #program = [3, 0, 4, 0, 99]

      #Advent.Day5.run_program(program)
    end

    test "immediate mode" do
      program = [1002, 4, 3, 4, 33]

      assert [1002, 4, 3, 4, 99] = Advent.Day5.run_program(program)
    end
  end
end
