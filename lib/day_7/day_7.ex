defmodule Advent.Day7 do
  def permutations([]), do: [[]]

  def permutations(list),
    do: for(elem <- list, rest <- permutations(list -- [elem]), do: [elem | rest])

  def solve_puzzle(filename) do
    {:ok, binary} = File.read("lib/day_7/#{filename}")

    intcode_program =
      binary
      |> String.split(",")
      |> Enum.map(fn x ->
        {i, _} = Integer.parse(x)
        i
      end)


    [5,6,7,8,9]
    |> permutations()
    |> Enum.reduce({nil, nil}, fn phase_settings, {best_signal, best_thrust} ->
      IO.inspect(phase_settings)
      {:thrust, value} = Advent.Day7.Threaded.main(intcode_program, phase_settings)

      with false <- is_nil(best_signal),
        true <- value < best_thrust do
        {best_signal, best_thrust}
        else
        _ ->
        {phase_settings, value}
      end
    end)
    |> IO.inspect()
  end


end
