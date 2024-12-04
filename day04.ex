defmodule Day04 do
  @spec count_x_mas(grid :: {{String}}) :: integer
  def count_x_mas(grid) do
    rows = (1..(tuple_size(grid) - 2))
    Enum.reduce(
      rows,
      0,
      fn row, acc ->
        cols = (1..(tuple_size(elem(grid, row)) - 2))
        Enum.reduce(
          cols,
          acc,
          fn col, cnt ->
            if has_x_mas_in_position(grid, row, col) do
              cnt + 1
            else
              cnt
            end
          end
        )
      end
    )
  end

  def get(grid, row, col), do: grid |> elem(row) |> elem(col)

  def has_x_mas_in_position(grid, row, col) do
    letters = [{"M", "S"}, {"S", "M"}]
    get(grid, row, col) == "A" and \
      Enum.member?(letters, {get(grid, row - 1, col - 1), get(grid, row + 1, col + 1)}) and \
      Enum.member?(letters, {get(grid, row - 1, col + 1), get(grid, row + 1, col - 1)})
  end

  def main() do
    Lib.read_lines()
    |> Enum.map(&Lib.string_to_tuple/1)
    |> List.to_tuple
    |> count_x_mas()
    |> IO.inspect(charlists: :as_lists, limit: :infinity)
  end
end
