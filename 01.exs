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

  def similarity_score([l1, l2]) do
    freq = Enum.frequencies(l2)

    l1
    |> Enum.map(fn x -> Map.get(freq, x, 0) * x end)
    |> Enum.sum
  end

  def main() do
    read_lines()
    |> split_into_lists()
    |> Tuple.to_list()
    |> Enum.map(&Enum.map(&1, fn str -> Integer.parse(str) |> elem(0) end))
    |> similarity_score
    |> IO.inspect()
  end
end

Day01.main()
