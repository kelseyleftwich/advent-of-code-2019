defmodule Advent.Day3 do
  def get_lines_from_file(filename) do
    {:ok, binary} = File.read("lib/day_3/#{filename}")

    binary
    |> String.split("\n")
  end

  def process_instructions(instructions) do
    instructions
    |> String.split(",")
    |> Enum.reduce([[0, 0]], fn instruction, acc ->
      [x, y] = Enum.at(acc, -1)
      {direction, number} = String.split_at(instruction, 1)
      {number, _} = Integer.parse(number)

      points =
        Enum.map(1..number, fn addend ->
          case direction do
            "U" ->
              [x, y + addend]

            "D" ->
              [x, y - addend]

            "L" ->
              [x - addend, y]

            "R" ->
              [x + addend, y]
          end
        end)

      acc ++ points
    end)
  end

  def get_common_points([line_1, line_2]) do
    line_1_points = process_instructions(line_1)

    line_2_points = process_instructions(line_2)

    line_2_points -- line_2_points -- line_1_points
  end

  def remove_origin(points) do
    Enum.filter(points, fn [x, y] ->
      x != 0 and y != 0
    end)
  end

  def get_min_distance(points) do
    Enum.reduce(points, nil, fn [x, y], acc ->
      current_distance = abs(x) + abs(y)

      with false <- is_nil(acc),
           true <- acc > current_distance do
        current_distance
      else
        true ->
          current_distance

        false ->
          acc
      end
    end)
  end

  def solve_puzzle_1(filename) do
    filename
    |> get_lines_from_file()
    |> get_common_points()
    |> remove_origin()
    |> get_min_distance()
  end

  def steps_to_point(point, line) do
    line
    |> process_instructions()
    |> Enum.find_index(fn coords ->
      coords == point
    end)
  end

  def steps_to_common_points(points, [first, second]) do
    Enum.reduce(points, nil, fn point, acc ->
      line_1_steps = steps_to_point(point, first)
      line_2_steps = steps_to_point(point, second)
      total_steps = line_1_steps + line_2_steps

      with false <- is_nil(acc),
           true <- total_steps < acc do
        total_steps
      else
        true -> total_steps
        false -> acc
      end
    end)
  end

  def solve_puzzle_2(filename) do
    lines =
      filename
      |> get_lines_from_file()

    lines
    |> get_common_points()
    |> remove_origin()
    |> steps_to_common_points(lines)
  end
end
