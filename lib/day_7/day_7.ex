defmodule Advent.Day7 do
  def permutations([]), do: [[]]

  def permutations(list),
    do: for(elem <- list, rest <- permutations(list -- [elem]), do: [elem | rest])

  def solve_puzzle(filename, phase_settings) do
    {:ok, binary} = File.read("lib/day_7/#{filename}")

    intcode_program =
      binary
      |> String.split(",")
      |> Enum.map(fn x ->
        {i, _} = Integer.parse(x)
        i
      end)

    # phase_settings
    # |> permutations()

    [[9,8,7,6,5]]
    |> Enum.reduce({nil, nil}, fn phase_setting, {best_signal, best_thrust} ->
      {current_signal, current_thrust} = compute(phase_setting, intcode_program,0)
      |> IO.inspect
      with false <- is_nil(best_signal),
        true <- best_thrust > current_thrust do
          {best_signal, best_thrust}
        else
          _ -> {current_signal, current_thrust}
        end
    end)
  end

  def compute(phase_setting, intcode_program, init_input_signal) do
    # IO.inspect(phase_setting)
    output =
      phase_setting
      |> Enum.each(fn p ->

          pid = spawn Advent.Day7.Intcode.run_program(intcode_program, {p, 0, nil})

          IO.inspect
      end)

    #{phase_setting, output}


    compute(phase_setting, intcode_program, output)

  end
end
