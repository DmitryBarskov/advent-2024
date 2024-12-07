defmodule Day06 do
  defguard in_range(tuple, y) when is_tuple(tuple) and 0 <= y and y < tuple_size(tuple)

  def main() do
    map = Lib.read_lines()
    |> Enum.map(&Lib.string_to_tuple/1)
    |> List.to_tuple

    start = map
    |> find_position("^")
    |> IO.inspect()

    {:out, path} = simulate_movement(map, start)
    IO.inspect(map_size(path))

    path
    |> Enum.count(
      fn {{y, x}, _} ->
        {result, _path} = simulate_movement(map, start, :up, Map.new, {y, x})
        {y, x} != start and result == :loop
      end
    )
    |> IO.inspect
  end

  def find_position(map, target) do
    0..(tuple_size(map) - 1)
    |> Enum.reduce_while(
      nil,
      fn row_index, _acc ->
        row = elem(map, row_index)

        found_in_row = Enum.find_index(
          0..(tuple_size(row) - 1),
          fn col_index -> elem(row, col_index) == target end
        )

        case found_in_row do
          nil -> {:cont, nil}
          col_index -> {:halt, {row_index, col_index}}
        end
      end
    )
  end

  def simulate_movement(map, start, direction \\ :up, visited \\ Map.new, extra_obstruction \\ {-1, -1})
  def simulate_movement(map, {y, _}, _, visited, _) when not in_range(map, y), do: {:out, visited}
  def simulate_movement(map, {y, x}, _, visited, _) when not in_range(elem(map, y), x), do: {:out, visited}
  def simulate_movement(map, {y, x}, direction, visited, extra_obstruction) do
    if Map.get(visited, {y, x}, MapSet.new()) |> MapSet.member?(direction) do
      {:loop, visited}
    else
      cell_in_front = move({y, x}, direction)

      if dig(map, cell_in_front) == "#" or cell_in_front == extra_obstruction do
        simulate_movement(
          map,
          {y, x},
          rotate(direction),
          Map.update(
            visited,
            {y, x},
            MapSet.new([direction]),
            fn v -> MapSet.put(v, direction) end
          ),
          extra_obstruction
        )
      else
        simulate_movement(
          map,
          cell_in_front,
          direction,
          Map.update(
            visited,
            {y, x},
            MapSet.new([direction]),
            fn v -> MapSet.put(v, direction) end
          ),
          extra_obstruction
        )
      end
    end
  end

  def move({y, x}, :up), do: {y - 1, x}
  def move({y, x}, :down), do: {y + 1, x}
  def move({y, x}, :left), do: {y, x - 1}
  def move({y, x}, :right), do: {y, x + 1}

  def rotate(:up), do: :right
  def rotate(:right), do: :down
  def rotate(:down), do: :left
  def rotate(:left), do: :up

  def dig(map, {y, x}) when in_range(map, y) and in_range(map |> elem(y), x), do: map |> elem(y) |> elem(x)
  def dig(_, _), do: nil
end
