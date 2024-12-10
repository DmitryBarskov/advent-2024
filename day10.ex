defmodule Day10 do
  def main() do
    Lib.read_lines
    |> Enum.map(&Lib.string_to_tuple/1)
    |> List.to_tuple
    |> sum_of_trailhead_scores
    |> IO.inspect
  end

  def sum_of_trailhead_scores(map) do
    Enum.map(
      0..(tuple_size(map) - 1),
      fn i ->
        Enum.map(
          0..(tuple_size(map |> elem(i)) - 1),
          fn j -> trail_head_to_end(map, i, j) |> MapSet.size end
        )
        |> Enum.sum
      end
    ) |> Enum.sum
  end

  defguard in_range(map, i) when 0 <= i and i < tuple_size(map)
  defguard in_range(map, i, j) when in_range(map, i) and 0 <= j and j < tuple_size(map |> elem(i))

  def trail_head_to_end(map, i, j, next_height \\ 0)
  def trail_head_to_end(map, i, j, 9) when in_range(map, i, j) and map |> elem(i) |> elem(j) == "9", do: MapSet.new([{i, j}])
  def trail_head_to_end(_, _, _, 9), do: MapSet.new()
  def trail_head_to_end(map, i, j, _) when not in_range(map, i, j), do: MapSet.new()
  def trail_head_to_end(map, i, j, next_height) do
    cond do
      map |> elem(i) |> elem(j) == Integer.to_string(next_height) ->
        adjacent(i, j)
        |> Enum.map(fn {y, x} -> trail_head_to_end(map, y, x, next_height + 1) end)
        |> Enum.reduce(MapSet.new(), fn set, all -> MapSet.union(all, set) end)
      true -> MapSet.new()
    end
  end

  def adjacent(y, x) do
    [{0, 1}, {1, 0}, {-1, 0}, {0, -1}]
    |> Enum.map(fn {dy, dx} -> {y + dy, x + dx} end)
  end
end
