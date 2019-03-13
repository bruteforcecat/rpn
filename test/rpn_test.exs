defmodule RPNTest do
  use ExUnit.Case
  doctest RPN

  test "return 1 given only 1" do
    assert RPN.calculate("1") == {:ok, 1.0}
  end

  test "return 9.0 given 3 6 * 2 /" do
    assert RPN.calculate("3 6 * 2 /") == {:ok, 9.0}
  end

  test "return -5.0 given 3 4 2 * -" do
    assert RPN.calculate("3 4 2 * -") == {:ok, -5.0}
  end

  test "return -29.0 given 1 30 -" do
    assert RPN.calculate("1 30 -") == {:ok, -29.0}
  end

  test "return 7.0 given 2 5 +" do
    assert RPN.calculate("2 5 +") == {:ok, 7.0}
  end

  test "return 3 given 2 5 - abs" do
    assert RPN.calculate("2 5 - abs") == {:ok, 3.0}
  end

  test "return error given empty string" do
    assert RPN.calculate("") == {:error, :empty_string_is_not_allowed}
  end

  test "return error given invalid token" do
    assert RPN.calculate("2 5 explode") == {:error, :invalid_token}
  end

  test "return error given invalid expression" do
    assert RPN.calculate("2 5") == {:error, :invalid_expression}
  end


end
