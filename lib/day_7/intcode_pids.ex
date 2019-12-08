defmodule Advent.Day7.Threaded do
  @moduledoc """
  Day 5: Sunny with a Chance of Asteroids
  """

  alias Advent.Math

  def main(program, [head | tail] = _signals) do
    {:registered_name, name} = Process.info(self(), :registered_name)

    IO.inspect("parent: #{name} #{inspect(self())}")
    me = self()

    a =
      spawn(fn ->
        start_program(
          program,
          head,
          tail,
          me
        )
      end)

    send(a, {:initial, 0})

    wait_for_message(a)
  end

  def wait_for_message(a) do
    receive do
      {:parent, value} ->
        # IO.inspect("parent sending passthrough #{value} to a")
        case Process.alive?(a) do
          true ->
            send(a, {:passthrough, value})
            wait_for_message(a)
          false ->
            {:thrust, value}
        end
    after
      6000 ->
        IO.inspect("timed out!")
    end

  end

  def run_program([99 | _tail] = program) do
    program
  end

  def start_program(program, phase_setting, [], parent) when not is_nil(phase_setting) do
    Process.register(self(), String.to_atom("0"))
    # IO.inspect(parent)

    send(self(), {:phase_setting, phase_setting})
    run_program(program, program, phase_setting, parent)
  end

  def start_program(program, phase_setting, siblings, parent)
      when is_list(siblings) and not is_nil(phase_setting) do
    send(self(), {:phase_setting, phase_setting})
    Process.register(self(), String.to_atom(Integer.to_string(length(siblings))))
    {:registered_name, name} = Process.info(self(), :registered_name)
    IO.inspect("#{phase_setting}: #{inspect(name)} parent: #{inspect(parent)}")
    [sibling_phase_setting | siblings_siblings] = siblings

    spawn_link(Advent.Day7.Threaded, :start_program, [
      program,
      sibling_phase_setting,
      siblings_siblings,
      parent
    ])

    run_program(program, program, phase_setting, parent)
  end

  def run_program(program, [99 | _tail], _phase_setting, _parent) do
    program
  end

  def run_program(
        program,
        [3 | [parameter | tail]],
        phase_setting,
        parent
      ) do
    {:registered_name, name} = Process.info(self(), :registered_name)

    {before_pos, [_discard | after_pos]} = Enum.split(program, parameter)

    case phase_setting do
      nil ->
        receive do
          {:initial, value} ->
            # IO.inspect("#{inspect(name)} received #{value} as init value")
            program = before_pos ++ [value] ++ after_pos

            move_pointer_and_run_program(program, tail, phase_setting, parent)

          {:child, value} ->
            program = before_pos ++ [value] ++ after_pos

            move_pointer_and_run_program(program, tail, phase_setting, parent)

          {:passthrough, value} ->
            program = before_pos ++ [value] ++ after_pos

            move_pointer_and_run_program(program, tail, phase_setting, parent)
        after
          5000 -> IO.puts("Timed out!")
        end

      _ ->
        # IO.inspect("#{inspect(name)} received #{phase_setting} as phase_setting")
        program = before_pos ++ [phase_setting] ++ after_pos

        move_pointer_and_run_program(program, tail, nil, parent)
    end
  end

  def run_program(
        program,
        [4 | [parameter | tail]],
        phase_setting,
        parent
      ) do
    value = get_value(0, parameter, program)

    # output_to_term("Output: #{value}")

    {:links, links} = Process.info(self(), :links)

    IO.inspect(links)

    {:registered_name, self_name} = Process.info(self(), :registered_name)

    {self_name, _} =
      self_name
      |> Atom.to_string()
      |> Integer.parse()

    filtered_links =
      Enum.filter(links, fn link ->
        {:registered_name, link_name} = Process.info(link, :registered_name)

        IO.inspect(link_name)

        {link_name, _} =
          link_name
          |> Atom.to_string()
          |> Integer.parse()

        link_name == self_name - 1
      end)

    # IO.inspect("#{length(filtered_links)} #{length(links)}")

    case filtered_links do
      [] ->
        Process.info(parent, :registered_name)
        # |> IO.inspect()
        # IO.inspect("#{self_name} sending #{value} to parent #{inspect(parent)}")
        send(parent, {:parent, value})

      _ ->
        for pid <- filtered_links do
          Process.info(pid, :registered_name)
          # |> IO.inspect()

          {:registered_name, link_name} = Process.info(pid, :registered_name)

          {link_name, _} =
            link_name
            |> Atom.to_string()
            |> Integer.parse()

          IO.inspect("#{self_name} sending #{value} to #{link_name}")
          send(pid, {:child, value})
        end
    end

    move_pointer_and_run_program(program, tail, phase_setting, parent)
  end

  def run_program(
        program,
        [instruction | tail],
        phase_setting,
        parent
      ) do
    op_code = rem(instruction, 100)

    instruction_digits = Integer.digits(instruction)

    instruction_digits =
      case length(instruction_digits) do
        4 ->
          instruction_digits

        _ ->
          case op_code == 1 or op_code == 2 or op_code == 6 or op_code == 5 or op_code == 7 or
                 op_code == 8 do
            true ->
              leading_zeros = List.duplicate(0, 4 - length(instruction_digits))

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
        case Enum.at(values, 0) do
          0 ->
            [_v1 | [_v2 | tail]] = tail
            move_pointer_and_run_program(program, tail, phase_setting, parent)

          _ ->
            {_before_pos, tail} = Enum.split(program, Enum.at(values, 1))
            move_pointer_and_run_program(program, tail, phase_setting, parent)
        end

      6 ->
        case Enum.at(values, 0) do
          0 ->
            {_before_pos, tail} = Enum.split(program, Enum.at(values, 1))
            move_pointer_and_run_program(program, tail, phase_setting, parent)

          _ ->
            [_v1 | [_v2 | tail]] = tail
            move_pointer_and_run_program(program, tail, phase_setting, parent)
        end

      _ ->
        case process_values(op_code, values) do
          nil ->
            {_head, tail} = Enum.split(tail, length(values))
            move_pointer_and_run_program(program, tail, phase_setting, parent)

          result ->
            insert_pos_digit_index =
              instruction_digits
              |> length
              |> Kernel.-(2)

            insert_pos = Enum.at(tail, insert_pos_digit_index)

            {before_pos, [_discard | after_pos]} = Enum.split(program, insert_pos)

            program = before_pos ++ [result] ++ after_pos

            {_head, tail} = Enum.split(tail, length(values) + 1)
            move_pointer_and_run_program(program, tail, phase_setting, parent)
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

  def move_pointer_and_run_program(program, tail, phase_setting, parent) do
    remaining_program = Enum.take(program, length(tail) * -1)

    run_program(program, remaining_program, phase_setting, parent)
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
    IO.puts(IO.ANSI.format([:yellow_background, :black, inspect(arg)]))
  end
end
