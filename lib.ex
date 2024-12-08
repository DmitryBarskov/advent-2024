defmodule Lib do
  def read_lines() do
    case IO.gets(nil) do
      :eof -> []
      line -> [String.trim(line) | read_lines()]
    end
  end

  def string_to_tuple(string), do: string_to_list(string) |> List.to_tuple

  def string_to_list(string), do: String.split(string, "", trim: true)

  def parse_int(string) do
    Integer.parse(string) |> elem(0)
  end
end
