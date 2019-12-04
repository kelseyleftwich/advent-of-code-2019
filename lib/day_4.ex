defmodule Advent.Day4 do
  def has_adjacent_digits(password) do
    {_prev, adjacent} =
      password
      |> get_digits()
      |> Enum.reduce({nil, false}, fn digit, {prev, adjacent} ->
        with false <- adjacent,
             false <- digit == prev do
          {digit, false}
        else
          true ->
            {digit, true}
        end
      end)

    adjacent
  end

  def sum_list([]) do
    0
  end

  def sum_list([h|t]) do
    h + sum_list(t)
  end

  def adjacent_digits_count_is_two(password) do
    password
    |> get_digits()
    |> Enum.group_by(&(&1), fn _ -> 1 end)
    |> Enum.reduce(false, fn {_digit, counts}, acc ->
      with false <- acc,
        false <- sum_list(counts) == 2 do
          false
        else
          true ->
            true
        end
    end)
  end

  def digits_never_decrease(password) do
    {_, valid} =
      password
      |> get_digits()
      |> Enum.reduce({nil, true}, fn digit, {prev, valid} ->
        with true <- valid,
            true <- digit >= prev do
          {digit, true}
        else
          false ->
            {digit, false}
        end
      end)

    valid
  end

  def get_digits(password) do
    for <<x::binary-1 <- password>>, do: x
  end

  def password_is_valid(password) do
    has_adjacent_digits(password) and digits_never_decrease(password) and adjacent_digits_count_is_two(password)
  end

  def valid_passwords_in_range() do
    Enum.reduce(134792..675810, 0, fn password, acc ->
      case password_is_valid("#{password}") do
        true ->
          acc + 1
        false ->
          acc
      end
    end)
  end
end
