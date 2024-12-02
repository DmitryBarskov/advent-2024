defmodule Day02 do
  import Lib, only: [read_lines: 0]

  def parse_report(line),
    do:
      line
      |> String.split(" ")
      |> Enum.map(fn x -> Integer.parse(x) |> elem(0) end)

  def safe?([_ | rest] = list),
    do:
      safe_increasing?(list, true) or \
      safe_increasing?(rest, false) or \
      safe_decreasing?(list, true) or \
      safe_decreasing?(rest, false)

  def safe_decreasing?([a, b], tolerant), do: tolerant or a > b and abs(a - b) <= 3
  def safe_decreasing?([a, b, c | rest], tolerant) do
    valid = a > b and abs(a - b) <= 3 and b > c and abs(b - c) <= 3
    cond do
      not valid and not tolerant -> false
      not valid and tolerant -> safe_decreasing?([a, b | rest], false) or safe_decreasing?([a, c | rest], false)
      valid -> safe_decreasing?([b, c | rest], tolerant)
    end
  end

  def safe_increasing?([a, b], tolerant), do: tolerant or a < b and abs(a - b) <= 3
  def safe_increasing?([a, b, c | rest], tolerant) do
    valid = a < b and abs(a - b) <= 3 and b < c and abs(b - c) <= 3
    cond do
      not valid and not tolerant -> false
      not valid and tolerant -> safe_increasing?([a, b | rest], false) or safe_increasing?([a, c | rest], false)
      valid -> safe_increasing?([b, c | rest], tolerant)
    end
  end

  def main() do
    read_lines()
    |> Enum.map(&parse_report/1)
    |> Enum.count(&safe?/1)
    |> IO.inspect(charlists: :as_lists, limit: :infinity)
  end
end
