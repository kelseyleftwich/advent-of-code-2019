defmodule Advent.Math do
  def sum_list([]) do
    0
  end

  def sum_list([head | tail]) do
    head + sum_list(tail)
  end

  def multiply_list(list) do
    Enum.reduce(list, 1, fn x, acc -> x * acc end)
  end
end
