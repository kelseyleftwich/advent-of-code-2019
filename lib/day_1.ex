defmodule Advent.Day1 do
  @moduledoc """
  Day 1: Fuel Counter Upper
  """

  @doc """
  Calculates fuel required for a list of masses

  ## Examples

    iex> Advent.Day1.calculate_fuel([12])
    2

    iex> Advent.Day1.calculate_fuel([12, 12])
    4

    iex> Advent.Day1.calculate_fuel([12, 14, 1969, 100756])
    51316
  """
  def calculate_fuel(masses) when is_list(masses) do
    Enum.reduce(masses, 0, fn mass, acc ->
      acc + calculate_fuel(mass)
    end)
  end

  def calculate_fuel(mass) when is_integer(mass) and mass <= 0, do: 0

  @doc """
  Calculates fuel required for mass

  ## Examples

    iex> Advent.Day1.calculate_fuel(12)
    2
  """
  @spec calculate_fuel(integer) :: integer
  def calculate_fuel(mass) do
    fuel =
      mass
      |> div(3)
      |> floor()
      |> subtract(2)
      |> round_up_if_negative()

    fuel + calculate_fuel(fuel)
  end

  defp subtract(a, b) do
    a - b
  end

  @doc """
  Return 0 if fuel amount passed in is not greater than 0, otherwise return fuel amount

  ## Examples

    iex> Advent.Day1.round_up_if_negative(12)
    12

    iex> Advent.Day1.round_up_if_negative(0)
    0

    iex> Advent.Day1.round_up_if_negative(-5)
    0
  """
  def round_up_if_negative(fuel) do
    case fuel > 0 do
      true -> fuel
      false -> 0
    end
  end

  @doc """
  Solves the puzzle
  """
  @spec solve_puzzle() :: integer
  def solve_puzzle() do
    masses = [
      101_005,
      139_223,
      112_833,
      70247,
      131_775,
      106_730,
      118_388,
      138_683,
      80439,
      71060,
      120_862,
      67201,
      70617,
      79783,
      114_813,
      77907,
      78814,
      107_515,
      113_507,
      81865,
      88130,
      75120,
      66588,
      56023,
      98080,
      128_472,
      96031,
      118_960,
      54069,
      112_000,
      62979,
      105_518,
      73342,
      52270,
      128_841,
      68267,
      70789,
      94792,
      100_738,
      102_331,
      83082,
      77124,
      97360,
      86165,
      66120,
      139_042,
      50390,
      105_308,
      94607,
      58225,
      77894,
      118_906,
      127_277,
      101_446,
      58897,
      93876,
      53312,
      117_154,
      77448,
      62041,
      99069,
      87375,
      134_854,
      108_561,
      126_406,
      53809,
      90760,
      121_650,
      79573,
      134_734,
      148_021,
      84263,
      54390,
      132_706,
      148_794,
      67302,
      146_885,
      76108,
      76270,
      54548,
      146_920,
      145_282,
      129_509,
      144_139,
      141_713,
      62547,
      149_898,
      96746,
      83583,
      107_758,
      63912,
      142_036,
      112_281,
      91775,
      75809,
      82250,
      144_667,
      140_140,
      98276,
      103_479
    ]

    calculate_fuel(masses)
  end
end
