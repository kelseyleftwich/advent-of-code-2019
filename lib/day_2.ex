defmodule Advent.Day2 do
  @moduledoc """
  Day 2: Intcode Program
  """

  def run_program([99 | _tail] = program) do
    program
  end

  def run_program(program) do
    run_program(program, program)
  end

  def run_program(program, [99 | _tail]) do
    program
  end

  def run_program(program, remaining_program) when length(remaining_program) > 4 do
    [pos_0 | [pos_1 | [pos_2 | [pos_4 | tail]]]] = remaining_program

    pos_1_value = Enum.at(program, pos_1)
    pos_2_value = Enum.at(program, pos_2)

    {before_pos, [_discard | after_pos]} = Enum.split(program, pos_4)

    program = before_pos ++ [process_ints(pos_0,pos_1_value, pos_2_value)] ++ after_pos

    remaining_program = Enum.take(program, length(tail)*-1)

    run_program(program, remaining_program)
  end

  def process_ints(1, a, b) do
    a + b
  end

  def process_ints(2, a, b) do
    a * b
  end

  def solve_puzzle_1() do
    inputs = [1,12,2,3,1,1,2,3,1,3,4,3,1,5,0,3,2,10,1,19,1,19,9,23,1,23,6,27,2,27,13,31,1,10,31,35,1,10,35,39,2,39,6,43,1,43,5,47,2,10,47,51,1,5,51,55,1,55,13,59,1,59,9,63,2,9,63,67,1,6,67,71,1,71,13,75,1,75,10,79,1,5,79,83,1,10,83,87,1,5,87,91,1,91,9,95,2,13,95,99,1,5,99,103,2,103,9,107,1,5,107,111,2,111,9,115,1,115,6,119,2,13,119,123,1,123,5,127,1,127,9,131,1,131,10,135,1,13,135,139,2,9,139,143,1,5,143,147,1,13,147,151,1,151,2,155,1,10,155,0,99,2,14,0,0]
    run_program(inputs)
  end

  def solve_puzzle_2() do
    Enum.each(0..99, fn noun ->
      Enum.each(0..99, fn verb ->
        inputs = [1,noun, verb,3,1,1,2,3,1,3,4,3,1,5,0,3,2,10,1,19,1,19,9,23,1,23,6,27,2,27,13,31,1,10,31,35,1,10,35,39,2,39,6,43,1,43,5,47,2,10,47,51,1,5,51,55,1,55,13,59,1,59,9,63,2,9,63,67,1,6,67,71,1,71,13,75,1,75,10,79,1,5,79,83,1,10,83,87,1,5,87,91,1,91,9,95,2,13,95,99,1,5,99,103,2,103,9,107,1,5,107,111,2,111,9,115,1,115,6,119,2,13,119,123,1,123,5,127,1,127,9,131,1,131,10,135,1,13,135,139,2,9,139,143,1,5,143,147,1,13,147,151,1,151,2,155,1,10,155,0,99,2,14,0,0]
        results = run_program(inputs)
        if Enum.at(results, 0) == 19690720 do
          IO.inspect("SOLUTION!!")
          IO.inspect(100 * noun + verb)
        end
      end)
    end)
  end
end