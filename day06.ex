defmodule Day06 do
  def main() do
    map = Lib.read_lines()
    |> Enum.map(&Lib.string_to_tuple/1)
    |> List.to_tuple

    start = map
    |> find_position("^")
    |> IO.inspect()

    simulate_movement(map, start, :up, Map.new())
    |> map_size
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

  defguard in_range(tuple, y) when is_tuple(tuple) and 0 <= y and y < tuple_size(tuple)

  def dig(map, {y, x}) when in_range(map, y) and in_range(map |> elem(y), x), do: map |> elem(y) |> elem(x)
  def dig(_, _), do: nil

  def simulate_movement(map, {y, _}, _, visited) when not in_range(map, y), do: visited
  def simulate_movement(_, {y, _}, :up, visited) when y <= 0, do: visited
  def simulate_movement(_, {_, x}, :left, visited) when x <= 0, do: visited
  def simulate_movement(map, {y, _}, :down, visited) when not in_range(map, y), do: visited
  def simulate_movement(map, {y, x}, :right, visited) when x >= tuple_size(elem(map, y)) - 1, do: visited
  def simulate_movement(map, {y, x}, direction, visited) do
    if Map.has_key?(visited, {y, x}) and Map.get(visited, {y, x}) |> MapSet.member?(direction) do
      visited
    else
      cell_in_front = move({y, x}, direction)

      next_direction = case {direction, dig(map, cell_in_front)} do
        {:up, "#"} -> :right
        {:right, "#"} -> :down
        {:down, "#"} -> :left
        {:left, "#"} -> :up
        {current_direction, _} -> current_direction
      end

      next_cell = move({y, x}, next_direction)

      simulate_movement(
        map,
        next_cell,
        next_direction,
        Map.update(
          visited,
          {y, x},
          MapSet.new([direction, next_direction]),
          fn v -> v |> MapSet.put(direction) |> MapSet.put(next_direction) end
        )
      )
    end
  end

  def move({y, x}, :up), do: {y - 1, x}
  def move({y, x}, :down), do: {y + 1, x}
  def move({y, x}, :left), do: {y, x - 1}
  def move({y, x}, :right), do: {y, x + 1}
end
