defmodule Advent.Day7.Intcode do
  @moduledoc """
  Day 5: Sunny with a Chance of Asteroids
  """

  alias Advent.Math

  def run_program([99 | _tail] = _program, {phase_setting, input_signal, output}) do
    {phase_setting, input_signal, output}
  end

  def run_program(program, {phase_setting, sibling}) do

    run_program(program, program)
  end

  def run_program(_program, [99 | _tail], {phase_setting, input_signal, output}) do
    {phase_setting, input_signal, output}
  end

  def run_program(
        program,
        [3 | [parameter | tail]],
        {phase_setting, input_signal, output}
      ) do

    {before_pos, [_discard | after_pos]} = Enum.split(program, parameter)

      case phase_setting do
        nil ->
          program = before_pos ++ [input_signal] ++ after_pos
          move_pointer_and_run_program(program, tail, {phase_setting, input_signal, output})
        _ ->
          program = before_pos ++ [phase_setting] ++ after_pos
          move_pointer_and_run_program(program, tail, {nil, input_signal, output})
      end
  end

  def run_program(
        program,
        [4 | [parameter | tail]],
        {phase_setting, input_signal, _output}
      ) do
    value = Enum.at(program, parameter)
    #output_to_term("Output: #{value}")


    move_pointer_and_run_program(program, tail, {phase_setting, input_signal, value})
  end

  def run_program(
        program,
        [instruction | tail],
        {phase_setting, input_signal, output}
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
              move_pointer_and_run_program(program, tail, {phase_setting, input_signal, output})
            _ ->
              {_before_pos, tail} = Enum.split(program, Enum.at(values, 1))
              move_pointer_and_run_program(program, tail, {phase_setting, input_signal, output})
          end
        6 ->
          case Enum.at(values,0) do
            0 ->
              {_before_pos, tail} = Enum.split(program, Enum.at(values,1))
              move_pointer_and_run_program(program, tail, {phase_setting, input_signal, output})
            _ ->
              [_v1 | [_v2 | tail ]] = tail
              move_pointer_and_run_program(program, tail, {phase_setting, input_signal, output})
          end
        _ ->
          case process_values(op_code, values) do
            nil ->
              {_head, tail} = Enum.split(tail, length(values))
              move_pointer_and_run_program(program, tail, {phase_setting, input_signal, output})
            result ->
              insert_pos_digit_index =
                instruction_digits
                |> length
                |> Kernel.-(2)

              insert_pos = Enum.at(tail, insert_pos_digit_index)

              {before_pos, [_discard | after_pos]} = Enum.split(program, insert_pos)

              program = before_pos ++ [result] ++ after_pos

              {_head, tail} = Enum.split(tail, length(values) + 1)
              move_pointer_and_run_program(program, tail, {phase_setting, input_signal, output})
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

  def move_pointer_and_run_program(program, tail, {phase_setting, input_signal, output}) do
    remaining_program = Enum.take(program, length(tail) * -1)

    run_program(program, remaining_program, {phase_setting, input_signal, output})
  end

  def process_values(1, values) do
    Math.sum_list(values)
  end

  def process_values(2, values) do
    Math.multiply_list(values)
  end

  def process_values(4, [value]) do
    #output_to_term("Output: #{value}")
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


end
