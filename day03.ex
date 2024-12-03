defmodule Day03 do
  def parse_instructions(line),
    do:
      Regex.scan(~r/mul\((\d{1,3}),(\d{1,3})\)|don't\(\)|do\(\)/, line)
      |> Enum.map(&parse_single_instruction/1)

  def parse_single_instruction([_mul_exp, arg1, arg2]),
    do: {:mul, elem(Integer.parse(arg1), 0), elem(Integer.parse(arg2), 0)}
  def parse_single_instruction(["don't()"]), do: {:dont}
  def parse_single_instruction(["do()"]), do: {:do}

  def eval_instructions(all_instructions) do
    all_instructions
    |> Enum.reduce(
      {:do, 0},
      fn
        {:mul, a, b}, {:do, acc} -> {:do, acc + a * b}
        {:mul, _, _}, {:dont, acc} -> {:dont, acc}
        {:dont}, {_state, acc} -> {:dont, acc}
        {:do}, {_state, acc} -> {:do, acc}
      end
    )
    |> elem(1)
  end

  def main() do
    Lib.read_lines()
    |> Enum.flat_map(&parse_instructions/1)
    |> eval_instructions()
    |> IO.inspect(charlists: :as_lists, limit: :infinity)
  end
end
