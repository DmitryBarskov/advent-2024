defmodule Day04 do
  @spec count_word(grid :: {{String}}, word :: charlist()) :: integer
  def count_word(grid, word) do
    rows = (0..(tuple_size(grid) - 1))
    Enum.reduce(
      rows,
      0,
      fn row, acc ->
        cols = (0..(tuple_size(elem(grid, row)) - 1))
        Enum.reduce(
          cols,
          acc,
          fn col, cnt ->
            cnt + count_word_in_position(grid, row, col, word)
          end
        )
      end
    )
  end

  def count_word_in_position(grid, row, col, word) do
    [{-1, 0}, {-1, 1}, {0, 1}, {1, 1}, {1, 0}, {1, -1}, {0, -1}, {-1, -1}]
    |> Enum.count(fn {dy, dx} -> has_word_in_direction(grid, row, col, word, dy, dx) end)
  end

  def has_word_in_direction(_, _, _, [], _, _), do: true
  def has_word_in_direction(_, row, col, _, _, _) when row < 0 or col < 0, do: false
  def has_word_in_direction(grid, row, _, _, _, _) when row >= tuple_size(grid), do: false
  def has_word_in_direction(grid, row, col, _, _, _) when col >= tuple_size(elem(grid, row)), do: false
  def has_word_in_direction(grid, row, col, [letter | rest], dy, dx) do
    (grid |> elem(row) |> elem(col)) == letter and \
      has_word_in_direction(grid, row + dy, col + dx, rest, dy, dx)
  end

  def main() do
    Lib.read_lines()
    |> Enum.map(&Lib.string_to_tuple/1)
    |> List.to_tuple
    |> count_word(String.split("XMAS", "", trim: true))
    |> IO.inspect(charlists: :as_lists, limit: :infinity)
  end
end
