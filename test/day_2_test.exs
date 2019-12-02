defmodule Advent.Day2Test do
  use ExUnit.Case

  describe "Day 2: Intcode Programs" do
    program = [1,9,10,3,2,3,11,0,99,30,40,50]

    assert [3500,9,10,70,2,3,11,0,99,30,40,50] = Advent.Day2.run_program(program)

    program = [1,0,0,0,99]

    assert [2,0,0,0,99] = Advent.Day2.run_program(program)

    program = [2,3,0,3,99]

    assert [2,3,0,6,99] = Advent.Day2.run_program(program)

    program = [2,4,4,5,99,0]

    assert [2,4,4,5,99,9801] = Advent.Day2.run_program(program)

    program = [1,1,1,4,99,5,6,0,99]

    assert [30,1,1,4,2,5,6,0,99] = Advent.Day2.run_program(program)
  end
end
