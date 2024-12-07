defmodule Day07 do
  def main() do
    Lib.read_lines()
    |> Enum.map(&parse_equation/1)
    |> Enum.filter(&can_be_true/1)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum
    |> IO.inspect(charlists: :as_lists)
  end

  def parse_equation(line) do
    [result, terms] = String.split(line, ": ")
    {Lib.parse_int(result), String.split(terms, " ") |> Enum.map(&Lib.parse_int/1)}
  end

  def can_be_true({result, [first_term | rest_terms]}), do: can_be_true_iter(result, rest_terms, first_term)

  def can_be_true_iter(result, [], total), do: result == total
  def can_be_true_iter(result, [next_term | rest], total) do
    can_be_true_iter(result, rest, total + next_term) or \
      can_be_true_iter(result, rest, total * next_term)
  end
end
