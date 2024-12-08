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
    |> find_all_atninodes({city_height, city_width})
    |> Enum.filter(&in_city(&1, {city_height, city_width}))
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

  def find_all_atninodes(antennas_by_frequency, city) do
    antennas_by_frequency
    |> Enum.reduce(
      MapSet.new(),
      fn {_freq, antennas}, set -> find_antinodes(antennas, set, city) end
    )
  end

  def find_antinodes([], result, _), do: result
  def find_antinodes([{_freq, y1, x1} | rest], result, city) do
    antinodes = Enum.reduce(
      rest, 
      result,
      fn {_freq, y2, x2}, antinodes ->
        ans = antinodes_for_two_antennas({y1, x1}, {y2, x2}, city)
        Enum.reduce(ans, antinodes, fn an, acc -> MapSet.put(acc, an) end)
      end
    )
    find_antinodes(rest, antinodes, city)
  end

  def antinodes_for_two_antennas({y1, x1}, {y2, x2}, city) do
    {dy, dx} = {y1 - y2, x1 - x2}
    right =
      Stream.unfold({y1, x1}, fn {y, x} -> {{y, x}, {y + dy, x + dx}} end)
      |> Enum.take_while(&in_city(&1, city))
    left =
      Stream.unfold({y1, x1}, fn {y, x} -> {{y, x}, {y - dy, x - dx}} end)
      |> Enum.take_while(&in_city(&1, city))
    left ++ right
  end

  def in_city({y, x}, {city_height, city_width}),
    do: 0 <= y and y < city_height and 0 <= x and x < city_width
end
