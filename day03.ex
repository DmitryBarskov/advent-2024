defmodule Day03 do
  import Lib, only: [read_lines: 0]

  def parse_instructions(line),
    do:
      Regex.scan(~r/mul\((\d{1,3}),(\d{1,3})\)/, line)
      |> Enum.map(fn [_ins, arg1, arg2] -> {elem(Integer.parse(arg1), 0), elem(Integer.parse(arg2), 0)} end)
      

  def main() do
    read_lines()
    |> Enum.flat_map(&parse_instructions/1)
    |> Enum.map(fn {a, b} -> a * b end)
    |> Enum.sum()
    |> IO.inspect(charlists: :as_lists, limit: :infinity)
  end
end
