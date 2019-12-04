defmodule Advent.Day4Test do
  use ExUnit.Case
  alias Advent.Day4

  describe "Day 4" do
    test "password_is_valid/1" do
      assert Day4.password_is_valid("111111")
      assert Day4.password_is_valid("111112")
      refute Day4.password_is_valid("223450")
      refute Day4.password_is_valid("123789")
      assert Day4.password_is_valid("122345")
    end

    test "" do
      assert Day4.adjacent_digits_count_is_two("112233")
      refute Day4.adjacent_digits_count_is_two("123444")
      assert Day4.adjacent_digits_count_is_two("111122")
    end
  end
end
