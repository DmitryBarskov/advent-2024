defmodule Day01 do
  def read_lines() do
    case IO.gets(nil) do
      :eof -> []
      line -> [String.trim(line) | read_lines()]
    end
  end

  def split_into_lists(input_lines) do
    input_lines
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.reduce({[], []}, fn [a, b], {l1, l2} -> {[a | l1], [b | l2]} end)
  end

  def list_diffs([l1, l2]) do
    Enum.zip_with(l1, l2, &diff/2)
  end

  def diff(x, y) do
    abs(x - y)
  end

  def main() do
    read_lines()
    |> split_into_lists()
    |> Tuple.to_list()
    |> Enum.map(&Enum.map(&1, fn str -> Integer.parse(str) |> elem(0) end))
    |> Enum.map(&Enum.sort/1)
    |> list_diffs
    |> Enum.sum
    |> IO.inspect()
  end
end

Day01.main()
