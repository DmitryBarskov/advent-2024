defmodule Day09 do
  def main() do
    [disk_map] = Lib.read_lines()

    disk_map
    |> parse_disk_map
    |> to_blocks
    |> compact
    |> checksum
    |> IO.inspect
  end

  def parse_disk_map(str), do: Lib.string_to_list(str) |> Enum.map(&Lib.parse_int/1)

  def to_blocks(disk_map), do: to_blocks_iter(disk_map, 0, [])

  def to_blocks_iter([], _, acc), do: Enum.reverse(acc)
  def to_blocks_iter([block_size], block_id, acc), do: to_blocks_iter([], block_id + 1, repeat(acc, block_id, block_size))
  def to_blocks_iter([block_size, space_size | rest], block_id, acc) do
    to_blocks_iter(rest, block_id + 1, repeat(acc, block_id, block_size) |> repeat(".", space_size))
  end

  def compact(blocks) do
    blocks = List.to_tuple(blocks)
    compact_iter(blocks, 0, tuple_size(blocks) - 1, [])
  end

  def compact_iter(_, i, j, acc) when i > j, do: Enum.reverse(acc)
  def compact_iter(blocks, i, j, acc) do
    case {elem(blocks, i), elem(blocks, j)} do
      {".", "."} -> compact_iter(blocks, i, j - 1, acc)
      {num, "."} -> compact_iter(blocks, i + 1, j, [num | acc])
      {".", num} -> compact_iter(blocks, i + 1, j - 1, [num | acc])
      {num, _nu} -> compact_iter(blocks, i + 1, j, [num | acc])
    end
  end

  def checksum(files) do
    files
    |> Enum.with_index
    |> Enum.map(
      fn
        {".", _} -> 0
        {fid, i} -> fid * i
      end
    )
    |> Enum.sum
  end

  def repeat(acc, _, 0), do: acc
  def repeat(acc, object, count), do: repeat([object | acc], object, count - 1)
end
