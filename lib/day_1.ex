defmodule Advent.Day1 do
  @moduledoc """
  Day 1: Fuel Counter Upper
  """

  @doc """

  """
  def calculate_fuel(masses) when is_list(masses) do
    Enum.reduce(masses, 0, fn mass, acc ->
      acc + calculate_fuel(mass)
    end)
  end

  @doc """
  Calculates fuel required for amount of mass

  ## Examples

    iex> Advent.Day1.calculate_fuel(12)
    2
  """
  @spec calculate_fuel(integer) :: integer
  def calculate_fuel(mass) do
    mass
    |> div(3)
    |> floor()
    |> subtract(2)
  end

  defp subtract(a, b) do
    a - b
  end
end
