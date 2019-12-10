defmodule Advent.Day10 do

  def solve(filename) do
    filename
    |> read_lines()
    |> get_points()
    |> best_point()
  end
  def read_lines(filename) do
    {:ok, binary} = File.read("lib/day_10/#{filename}")

      binary
      |> String.split("\n")
  end

  def get_points(rows) do
    rows
    |> Enum.with_index()
    |> Enum.map(fn {row, y} ->
      row
      |> String.graphemes
      |> Enum.with_index()
      |> Enum.reduce([], fn {cell, x}, acc ->
        case cell do
          "#" ->
            acc ++ [{x, y}]
          _ ->
            acc
        end
      end)
    end)
    |> List.flatten()
  end

  def best_point(points) do
    points
    |> Enum.reduce({nil, nil}, fn point, {best_point, best_slopes} ->
      current_slope = slopes_for_point(points, point)
      with false <- is_nil(best_point),
        false <- current_slope > best_slopes do
          {best_point, best_slopes}
        else
          true ->
            {point, current_slope}
        end
    end)
  end

  def slopes_for_point(points, {x, y} = _point) do
    points
    |> Enum.filter(fn {x_c, y_c} ->
      not(x == x_c and y == y_c)
    end)
    |> Enum.map(fn {x_c, y_c} ->
      with false <- x == x_c,
        false <- y == y_c do
          slope = (y - y_c) / (x - x_c)
          horizontal_direction =
            case x_c > x do
              true -> # to the right
                "R"
              false -> # to the left
                "L"
            end
          vertical_direction =
            case y_c > y do
              true -> # to the bottom
                "D"
              false -> # to the top
                "U"
            end
          "#{slope}#{horizontal_direction}#{vertical_direction}"
        else
          true ->
            case x == x_c do
              true -> # vertical line
                case y > y_c do
                  true -> "-v"
                  false -> "+v"
                end
              false -> # horizontal line
                case x > x_c do
                  true -> "-h"
                  false -> "+h"
                end
            end
        end
    end)
    |> Enum.uniq()
    |> Enum.count()
  end
end
