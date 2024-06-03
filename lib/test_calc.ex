defmodule TestCalc do
@moduledoc """
Test Calculator app
"""

  # Basic operations
  def add(num1, num2), do: num1 + num2
  def subtract(num1, num2), do: num1 - num2
  def multiply(num1, num2), do: num1 * num2
  def divide(num1, num2), do: num1 / num2
  def exponent(num1, num2), do: :math.pow(num1, num2)



  def get_input() do
    input = IO.gets("Enter your desired operation: ")
    input
  end

  def clean_input(input \\ nil) do
    input = input || get_input()

    clean_input =
      input
      |> String.trim()
      |> String.downcase()
      |> String.replace(~r/\s+/, "")

    clean_input
  end

  def tokenizer(input \\ nil) do
    input = input || clean_input()

    tokens =
      Regex.scan(~r/\d+(\.\d+)?|\.[0-9]+|[^a-z0-9\s]/, input)
      |> List.flatten()

    tokens = Enum.filter(tokens, fn token -> !String.starts_with?(token, ".") end)

    tokens
  end

  def to_number(tokens \\ nil) do
    tokens = tokens || tokenizer()

    tokens
    |> Enum.map(&convert_to_integer/1)
    |> Enum.map(&convert_to_float/1)
  end

  # Handle integers
  defp convert_to_integer(token) when is_integer(token), do: token
  defp convert_to_integer(token) when is_binary(token) do
    case String.match?(token, ~r/^-?\d+$/) do
      true -> String.to_integer(token)
      _ -> token
    end
  end

  defp convert_to_integer(token), do: token

  # Handle floats
  defp convert_to_float(token) when is_float(token), do: token
  # Handle floats
  # Handle integers
  defp convert_to_float(token) when is_binary(token) do
    case String.match?(token, ~r/^[+-]?(\d*\.\d+|\d+\.\d*)$/) do
      true -> String.to_float(token)
      _ -> token
    end
  end

  defp convert_to_float(token), do: token


  # Apply operations based on tokens
  defp precedence("+"), do: 1
  defp precedence("-"), do: 1
  defp precedence("*"), do: 2
  defp precedence("/"), do: 2
  defp precedence("^"), do: 3

  defp is_operator(token), do: token in ["+", "-", "*", "/", "^"]

  def infix_to_postfix(tokens \\ nil) do
    tokens = tokens || to_number()

    {output, ops} =
      Enum.reduce(tokens, {[], []}, fn
        token, {output, ops} when is_number(token) -> {[token | output], ops}
        token, {output, ops} when is_binary(token) ->
          if is_operator(token) do
            {new_output, new_ops} = pop_operators(token, output, ops)
            {new_output, [token | new_ops]}
          else
            {output, [token | ops]}
          end
      end)

    Enum.reverse(output) ++ ops
  end




  defp pop_operators(token, output, ops) do
    {ops_to_output, new_ops} =
      Enum.split_while(ops, fn op ->
        is_operator(op) and precedence(op) >= precedence(token)
      end)

    {Enum.reverse(ops_to_output) ++ output, new_ops}
  end

  def evaluate_postfix(tokens \\ nil) do
    tokens = tokens || infix_to_postfix()

    result =
      Enum.reduce(tokens, [], fn
        token, stack when is_number(token) -> [token | stack]
        token, [b, a | rest] -> [apply_operator(token, a, b) | rest]
      end)
      |> List.first()

    result
  end

  defp apply_operator("+", left, right), do: add(left, right)
  defp apply_operator("-", left, right), do: subtract(left, right)
  defp apply_operator("*", left, right), do: multiply(left, right)
  defp apply_operator("/", left, right), do: divide(left, right)
  defp apply_operator("^", left, right), do: exponent(left, right)



end

















defmodule Test do
  @moduledoc """
  Documentation for `TestCalc`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> TestCalc.hello()
      :world

  """
  def hello do
    :world
  end

  def leap_year?(year) do
    cond do
      rem(year, 400) == 0 -> true
      rem(year, 100) == 0 -> false
      rem(year, 4) == 0 -> true
      true -> false
    end
  end

  def score({x, y}) when is_integer(x) and is_integer(y) do
    cond do
      x < 0 or y < 0 -> 0
      x <= 1 and y <= 1 -> 10
      x <= 5 and y <= 5 -> 5
      x <= 10 and y <= 10 -> 1
      true -> 0
    end
  end

  def add(list, language) do
    # Please implement the add/2 function
    [language | list]
  end

  def first(list) do
    # Please implement the first/1 function
    [head | _tail] = list
    head
  end

end
