defmodule Day02 do
  import Lib, only: [read_lines: 0]
  require Integer

  def parse_report(line),
    do:
      line
      |> String.split(" ")
      |> Enum.map(fn x -> Integer.parse(x) |> elem(0) end)

  def safe?([first, second | rest] = list) when first > second,
    do: safe_decreasing?(list)
  def safe?([first, second | rest] = list) when first < second,
    do: safe_increasing?(list)
  def safe?(_), do: false

  def safe_decreasing?([]), do: true
  def safe_decreasing?([_]), do: true
  def safe_decreasing?([a, b | rest]),
    do: a > b and abs(a - b) <= 3 and safe_decreasing?([b | rest])

  def safe_increasing?([]), do: true
  def safe_increasing?([_]), do: true
  def safe_increasing?([a, b | rest]),
    do: a < b and abs(a - b) <= 3 and safe_increasing?([b | rest])

  def main() do
    read_lines()
    |> Enum.map(&parse_report/1)
    |> Enum.map(fn rep -> {rep, safe?(rep)} end)
    |> IO.inspect(charlists: :as_lists, limit: :infinity)
    |> Enum.count(fn {_rep, safe} -> safe end)
    |> IO.inspect()
  end
end
