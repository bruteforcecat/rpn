defmodule RPN do
  @moduledoc """
  Documentation for DistruInterview.
  """

  @doc """
  ## Examples

      iex> RPN.calculate("3 6 * 2 /")
      9.0

      iex> RPN.calculate("3 4 2 * -")
      -5.0

      iex> RPN.calculate("1 30 -")
      -29.0

      iex> RPN.calculate("2 5 +")
      7.0

      iex> RPN.calculate("1")
      1.0

      iex> RPN.calculate("2 5 - abs")
      3.0
  """

  @type error :: term()

  @double_operators ~w(+ - * /)
  @single_operators ~w(abs)
  @operators @double_operators ++ @single_operators

  @spec calculate(binary()) :: {:ok, float()} | {:error, error}
  def calculate(code) do
    code
    |> parse
    |> eval([])
  end

  defp parse(code) do
    code
    |> String.split(" ")
    |> Enum.map(&string_to_token/1)
  end

  defp string_to_token(str) when str in @operators do
    str
  end

  defp string_to_token(str) do
    {num, _} = Float.parse(str)
    num
  end

  defp eval([], [acc]) do
    acc
  end

  defp eval([x | xs] = tokens, [num1, num2 | rest])
       when is_list(tokens) and x in @double_operators do
    result = compute(x, num1, num2)
    eval(xs, [result | rest])
  end

  defp eval([x | xs] = tokens, [num | rest])
       when is_list(tokens) and x in @single_operators do
    result = compute(x, num)
    eval(xs, [result | rest])
  end

  defp eval([x | xs], acc) do
    eval(xs, [x | acc])
  end

  defp compute("abs", num) do
    Kernel.abs(num)
  end

  defp compute("*", num1, num2) do
    num2 * num1
  end

  defp compute("-", num1, num2) do
    num2 - num1
  end

  defp compute("+", num1, num2) do
    num2 + num1
  end

  defp compute("/", num1, num2) do
    num2 / num1
  end
end
