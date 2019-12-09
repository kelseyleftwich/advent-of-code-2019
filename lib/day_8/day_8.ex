defmodule Advent.Day8 do
  @moduledoc """
  Day 8: Space Image Format
  """

  def get_layers(input, width, height) when not is_list(input) do
    input
    |> Integer.digits()
    |> Enum.chunk_every(width * height)
  end

  def get_layers(input, width, height) when is_list(input) do
    input
    |> Enum.chunk_every(width * height)
  end

  def fewest_zeros_layer(input, width, height) do
    {layer, _count} =
      input
      |> get_layers(width, height)
      |> Enum.reduce({nil, nil}, fn layer, {acc_layer, acc_zero_count} ->
        num_zeros = Enum.count(layer, fn digit -> digit == 0 end)

        with false <- is_nil(acc_zero_count),
            true <- acc_zero_count < num_zeros do
          {acc_layer, acc_zero_count}
        else
          _ ->
            {layer, num_zeros}
        end
      end)

    layer
  end

  def multiply_ones_count_twos_count(layer) do
    ones = Enum.count(layer, fn p -> p == 1 end)
    twos = Enum.count(layer, fn p -> p == 2 end)

    ones * twos
  end

  def get_data_from_file(filename) do
    {:ok, binary} = File.read("lib/day_8/#{filename}")

    binary
  end

  def solve(filename, width, height) do
    {input, _} =
      get_data_from_file(filename)
      |> Integer.parse()

    input
    |> fewest_zeros_layer(width, height)
    |> multiply_ones_count_twos_count()
  end

  def solve_2(filename, width, height) do
    input =
      get_data_from_file(filename)
      |> String.graphemes

    input
    |> get_layers(width, height)
    |> get_pixels(width)
  end

  def get_pixels(layers, width) do
    last_index =
      layers
      |> Enum.at(0)
      |> length()
      |> Kernel.-(1)

    Enum.map(0..last_index, fn pos ->
      layers
      |> Enum.reduce_while(nil, fn layer, _acc ->
        case Enum.at(layer, pos) do
          "0" ->
            {:halt, "◼️"}
          "1" ->
            {:halt, "◻️"}
          "2" ->
            {:cont, "2"}
        end
      end)
    end)
    |> Enum.chunk_every(width)
    |> Enum.each(fn x -> IO.puts Enum.join(x) end)

  end
end
