defmodule Day08 do
  def main() do
    city =
      Lib.read_lines()
      |> Enum.map(&Lib.string_to_list/1)

    city_height = length(city)
    city_width = length(hd(city))
    IO.inspect({city_height, city_width}, label: "City size")

    city
    |> find_antennas
    |> Enum.group_by(fn {freq, _, _} -> freq end)
    |> find_all_atninodes
    |> Enum.filter(
      fn {y, x} ->
        0 <= y and y < city_height and 0 <= x and x < city_width
      end
    )
    |> length
    |> IO.inspect()
  end

  def find_antennas(map) do
    map
    |> Enum.with_index
    |> Enum.reduce(
      [],
      fn {row, i}, antennas ->
        row
        |> Enum.with_index
        |> Enum.reduce(
          antennas,
          fn
            {".", _}, antennas -> antennas
            {freq, j}, antennas -> [{freq, i, j} | antennas]
          end
        )
      end
    )
  end

  def find_all_atninodes(antennas_by_frequency) do
    antennas_by_frequency
    |> Enum.reduce(
      MapSet.new(),
      fn {_freq, antennas}, set -> find_antinodes(antennas, set) end
    )
  end

  def find_antinodes(antennas, result \\ MapSet.new())
  def find_antinodes([], result), do: result
  def find_antinodes([{_freq, y1, x1} | rest], result) do
    antinodes = Enum.reduce(
      rest, 
      result,
      fn {_freq, y2, x2}, antinodes ->
        [an1, an2] = antinodes_for_two_antennas({y1, x1}, {y2, x2})
        antinodes |> MapSet.put(an1) |> MapSet.put(an2)
      end
    )
    find_antinodes(rest, antinodes)
  end

  def antinodes_for_two_antennas({y1, x1}, {y2, x2}) do
    {dy, dx} = {y1 - y2, x1 - x2}
    [
      {y1 + dy, x1 + dx},
      {y2 - dy, x2 - dx}
    ]
  end
end
