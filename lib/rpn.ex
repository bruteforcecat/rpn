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
  @type unary_operator :: :abs
  @type binary_operator :: :+ | :- | :* | :/
  @type operator :: unary_operator | binary_operator
  @type token :: integer | operator

  @binary_operator ~w(+ - * /)a
  @unary_operator ~w(abs)a
  @operator @binary_operator ++ @unary_operator
  # it's verbose here but typespec only supporting atom and we only want to convert stirng to atom if there are operator
  # to avoid DDOS by atom attack
  @operator_in_strong Enum.map(@operator, &to_string/1)

  @spec calculate(binary()) :: {:ok, float()} | {:error, error}
  def calculate(expression) do
    expression
    |> parse
    |> eval([])
  end

  defp parse(code) do
    code
    |> String.split(" ")
    |> Enum.map(&to_token/1)
  end

  defp to_token(str) when str in @operator_in_strong do
    str
    |> String.to_atom()
  end

  defp to_token(str) do
    {num, _} = Float.parse(str)
    num
  end

  defp eval([], [acc]) do
    acc
  end

  defp eval([x | xs] = tokens, [num1, num2 | rest])
       when is_list(tokens) and x in @binary_operator do
    result = compute(x, num1, num2)
    eval(xs, [result | rest])
  end

  defp eval([x | xs] = tokens, [num | rest])
       when is_list(tokens) and x in @unary_operator do
    result = compute(x, num)
    eval(xs, [result | rest])
  end

  defp eval([x | xs], acc) do
    eval(xs, [x | acc])
  end

  defp compute(:abs, num) do
    Kernel.abs(num)
  end

  defp compute(:*, num1, num2) do
    num2 * num1
  end

  defp compute(:-, num1, num2) do
    num2 - num1
  end

  defp compute(:+, num1, num2) do
    num2 + num1
  end

  defp compute(:/, num1, num2) do
    num2 / num1
  end
end
