defmodule Lib do
  def read_lines() do
    case IO.gets(nil) do
      :eof -> []
      line -> [String.trim(line) | read_lines()]
    end
  end

  def string_to_tuple(string) do
    String.split(string, "", trim: true) |> List.to_tuple
  end

  def parse_int(string) do
    Integer.parse(string) |> elem(0)
  end
end
