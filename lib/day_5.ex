defmodule Advent.Day5 do
  @moduledoc """
  Day 5: Sunny with a Chance of Asteroids
  """

  alias Advent.Math

  def run_program([99 | _tail] = program) do
    program
  end

  def run_program(program) do
    run_program(program, program)
  end

  def run_program(program, [99 | _tail]) do
    program
  end

  def run_program(
        program,
        [3 | [parameter | tail]]
      ) do
    input = IO.gets("Input: ")
    {value, _} = Integer.parse(input)

    {before_pos, [_discard | after_pos]} = Enum.split(program, parameter)

    program = before_pos ++ [value] ++ after_pos
    move_pointer_and_run_program(program, tail)
  end

  def run_program(
        program,
        [4 | [parameter | tail]]
      ) do
    value = Enum.at(program, parameter)
    output_to_term("Output: #{value}")
    move_pointer_and_run_program(program, tail)
  end

  def run_program(
        program,
        [instruction | tail]
      ) do

    op_code = rem(instruction, 100)

    instruction_digits =
      Integer.digits(instruction)

    instruction_digits =
      case length(instruction_digits) do
        4 ->
          instruction_digits
        _ ->
          case op_code == 1 or op_code == 2 or op_code == 6 or op_code ==5 or op_code == 7 or op_code == 8 do
            true ->
            leading_zeros =
              List.duplicate(0, 4 - length(instruction_digits))

              leading_zeros ++ instruction_digits
            false ->
              instruction_digits
            end
      end

    values =
      instruction_digits
      |> Enum.reverse()
      |> Enum.drop(2)
      |> Enum.with_index()
      |> Enum.map(fn {mode, index} ->
        get_value(mode, Enum.at(tail, index), program)
      end)

      case op_code do
        5 ->
          case Enum.at(values,0) do
            0 ->
              [_v1 | [_v2 | tail ]] = tail
              move_pointer_and_run_program(program, tail)
            _ ->
              {_before_pos, tail} = Enum.split(program, Enum.at(values, 1))
              move_pointer_and_run_program(program, tail)
          end
        6 ->
          case Enum.at(values,0) do
            0 ->
              {_before_pos, tail} = Enum.split(program, Enum.at(values,1))
              move_pointer_and_run_program(program, tail)
            _ ->
              [_v1 | [_v2 | tail ]] = tail
              move_pointer_and_run_program(program, tail)
          end
        _ ->
          case process_values(op_code, values) do
            nil ->
              {_head, tail} = Enum.split(tail, length(values))
              move_pointer_and_run_program(program, tail)
            result ->
              insert_pos_digit_index =
                instruction_digits
                |> length
                |> Kernel.-(2)

              insert_pos = Enum.at(tail, insert_pos_digit_index)

              {before_pos, [_discard | after_pos]} = Enum.split(program, insert_pos)

              program = before_pos ++ [result] ++ after_pos

              {_head, tail} = Enum.split(tail, length(values) + 1)
              move_pointer_and_run_program(program, tail)
          end
      end

  end

  def get_value(0 = _mode, param, program) do
    Enum.at(program, param)
  end

  # immediate mode
  def get_value(1 = _mode, param, _program) do
    param
  end

  def move_pointer_and_run_program(program, tail) do
    remaining_program = Enum.take(program, length(tail) * -1)

    run_program(program, remaining_program)
  end

  def process_values(1, values) do
    Math.sum_list(values)
  end

  def process_values(2, values) do
    Math.multiply_list(values)
  end

  def process_values(4, [value]) do
    output_to_term("Output: #{value}")
    nil
  end

  def process_values(8 = _op_code, [value_1, value_2]) do
    case value_1 == value_2 do
      true ->
        1
      false ->
        0
    end
  end

  def process_values(7 = _op_code, [value_1, value_2]) do
    case value_1 < value_2 do
      true ->
        1
      false ->
        0
    end
  end

  def output_to_term(arg) do
    IO.puts IO.ANSI.format([:yellow_background, :black, inspect(arg)])
  end

  def solve_puzzle_1() do
    inputs = [
      3,
      225,
      1,
      225,
      6,
      6,
      1100,
      1,
      238,
      225,
      104,
      0,
      1102,
      16,
      13,
      225,
      1001,
      88,
      68,
      224,
      101,
      -114,
      224,
      224,
      4,
      224,
      1002,
      223,
      8,
      223,
      1001,
      224,
      2,
      224,
      1,
      223,
      224,
      223,
      1101,
      8,
      76,
      224,
      101,
      -84,
      224,
      224,
      4,
      224,
      102,
      8,
      223,
      223,
      101,
      1,
      224,
      224,
      1,
      224,
      223,
      223,
      1101,
      63,
      58,
      225,
      1102,
      14,
      56,
      224,
      101,
      -784,
      224,
      224,
      4,
      224,
      102,
      8,
      223,
      223,
      101,
      4,
      224,
      224,
      1,
      223,
      224,
      223,
      1101,
      29,
      46,
      225,
      102,
      60,
      187,
      224,
      101,
      -2340,
      224,
      224,
      4,
      224,
      102,
      8,
      223,
      223,
      101,
      3,
      224,
      224,
      1,
      224,
      223,
      223,
      1102,
      60,
      53,
      225,
      1101,
      50,
      52,
      225,
      2,
      14,
      218,
      224,
      101,
      -975,
      224,
      224,
      4,
      224,
      102,
      8,
      223,
      223,
      1001,
      224,
      3,
      224,
      1,
      223,
      224,
      223,
      1002,
      213,
      79,
      224,
      101,
      -2291,
      224,
      224,
      4,
      224,
      102,
      8,
      223,
      223,
      1001,
      224,
      2,
      224,
      1,
      223,
      224,
      223,
      1,
      114,
      117,
      224,
      101,
      -103,
      224,
      224,
      4,
      224,
      1002,
      223,
      8,
      223,
      101,
      4,
      224,
      224,
      1,
      224,
      223,
      223,
      1101,
      39,
      47,
      225,
      101,
      71,
      61,
      224,
      101,
      -134,
      224,
      224,
      4,
      224,
      102,
      8,
      223,
      223,
      101,
      2,
      224,
      224,
      1,
      224,
      223,
      223,
      1102,
      29,
      13,
      225,
      1102,
      88,
      75,
      225,
      4,
      223,
      99,
      0,
      0,
      0,
      677,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      1105,
      0,
      99999,
      1105,
      227,
      247,
      1105,
      1,
      99999,
      1005,
      227,
      99999,
      1005,
      0,
      256,
      1105,
      1,
      99999,
      1106,
      227,
      99999,
      1106,
      0,
      265,
      1105,
      1,
      99999,
      1006,
      0,
      99999,
      1006,
      227,
      274,
      1105,
      1,
      99999,
      1105,
      1,
      280,
      1105,
      1,
      99999,
      1,
      225,
      225,
      225,
      1101,
      294,
      0,
      0,
      105,
      1,
      0,
      1105,
      1,
      99999,
      1106,
      0,
      300,
      1105,
      1,
      99999,
      1,
      225,
      225,
      225,
      1101,
      314,
      0,
      0,
      106,
      0,
      0,
      1105,
      1,
      99999,
      1107,
      677,
      677,
      224,
      102,
      2,
      223,
      223,
      1006,
      224,
      329,
      1001,
      223,
      1,
      223,
      108,
      677,
      677,
      224,
      1002,
      223,
      2,
      223,
      1005,
      224,
      344,
      101,
      1,
      223,
      223,
      1008,
      226,
      226,
      224,
      102,
      2,
      223,
      223,
      1006,
      224,
      359,
      1001,
      223,
      1,
      223,
      1107,
      226,
      677,
      224,
      102,
      2,
      223,
      223,
      1006,
      224,
      374,
      1001,
      223,
      1,
      223,
      8,
      677,
      226,
      224,
      102,
      2,
      223,
      223,
      1006,
      224,
      389,
      101,
      1,
      223,
      223,
      8,
      226,
      226,
      224,
      102,
      2,
      223,
      223,
      1006,
      224,
      404,
      101,
      1,
      223,
      223,
      7,
      677,
      677,
      224,
      1002,
      223,
      2,
      223,
      1006,
      224,
      419,
      101,
      1,
      223,
      223,
      7,
      677,
      226,
      224,
      1002,
      223,
      2,
      223,
      1005,
      224,
      434,
      101,
      1,
      223,
      223,
      1108,
      677,
      226,
      224,
      1002,
      223,
      2,
      223,
      1006,
      224,
      449,
      1001,
      223,
      1,
      223,
      108,
      677,
      226,
      224,
      1002,
      223,
      2,
      223,
      1006,
      224,
      464,
      101,
      1,
      223,
      223,
      1108,
      226,
      677,
      224,
      1002,
      223,
      2,
      223,
      1006,
      224,
      479,
      101,
      1,
      223,
      223,
      1007,
      677,
      677,
      224,
      1002,
      223,
      2,
      223,
      1006,
      224,
      494,
      1001,
      223,
      1,
      223,
      107,
      226,
      226,
      224,
      102,
      2,
      223,
      223,
      1005,
      224,
      509,
      1001,
      223,
      1,
      223,
      1008,
      677,
      226,
      224,
      102,
      2,
      223,
      223,
      1005,
      224,
      524,
      1001,
      223,
      1,
      223,
      1007,
      226,
      226,
      224,
      102,
      2,
      223,
      223,
      1006,
      224,
      539,
      101,
      1,
      223,
      223,
      1108,
      677,
      677,
      224,
      102,
      2,
      223,
      223,
      1005,
      224,
      554,
      1001,
      223,
      1,
      223,
      1008,
      677,
      677,
      224,
      1002,
      223,
      2,
      223,
      1006,
      224,
      569,
      101,
      1,
      223,
      223,
      1107,
      677,
      226,
      224,
      1002,
      223,
      2,
      223,
      1006,
      224,
      584,
      1001,
      223,
      1,
      223,
      7,
      226,
      677,
      224,
      102,
      2,
      223,
      223,
      1005,
      224,
      599,
      101,
      1,
      223,
      223,
      108,
      226,
      226,
      224,
      1002,
      223,
      2,
      223,
      1005,
      224,
      614,
      101,
      1,
      223,
      223,
      107,
      226,
      677,
      224,
      1002,
      223,
      2,
      223,
      1005,
      224,
      629,
      1001,
      223,
      1,
      223,
      107,
      677,
      677,
      224,
      1002,
      223,
      2,
      223,
      1006,
      224,
      644,
      101,
      1,
      223,
      223,
      1007,
      677,
      226,
      224,
      1002,
      223,
      2,
      223,
      1006,
      224,
      659,
      101,
      1,
      223,
      223,
      8,
      226,
      677,
      224,
      102,
      2,
      223,
      223,
      1005,
      224,
      674,
      1001,
      223,
      1,
      223,
      4,
      223,
      99,
      226
    ]

    run_program(inputs)
  end
end
