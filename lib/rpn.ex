defmodule RPN do
  @moduledoc """
  Documentation for DistruInterview.
  """

  @doc """
  ## Examples
      iex> RPN.calculate("2 5 - abs")
      {:ok, 3.0}

      iex> RPN.calculate("abs")
      {:error, :invalid_expression}
  """

  @type error :: :empty_string_is_not_allowed | :invalid_token | :invalid_expression
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
    with {:ok, tokens} <- parse(expression),
         {:ok, result} <- eval(tokens, []) do
      {:ok, result}
    end
  end

  defp parse("") do
    {:error, :empty_string_is_not_allowed}
  end

  defp parse(expression) do
    case expression
         |> String.split(" ")
         |> Enum.reduce_while(
           [],
           fn x, acc ->
             case to_token(x) do
               {:ok, token} ->
                 {:cont, [token | acc]}

               {:error, error} ->
                 {:halt, {:error, error}}
             end
           end
         ) do
      {:error, error} ->
        {:error, error}

      tokens ->
        {:ok, Enum.reverse(tokens)}
    end
  end

  defp to_token(str) when str in @operator_in_strong do
    {:ok,
     str
     |> String.to_atom()}
  end

  defp to_token(str) do
    case Float.parse(str) do
      :error ->
        {:error, :invalid_token}

      {num, _} ->
        {:ok, num}
    end
  end

  defp eval([], [acc]) when is_float(acc) do
    {:ok, acc}
  end

  defp eval([], [_]) do
    {:error, :invalid_expression}
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

  defp eval(_, _) do
    {:error, :invalid_expression}
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
