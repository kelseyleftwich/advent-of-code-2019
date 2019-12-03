defmodule Advent.Day3 do
  def get_lines_from_file(path) do
    {:ok, binary} = File.read("lib/day_3/#{path}")

    binary
    |> String.split("\n")
  end


end
