defmodule Day05 do
  def main() do
    {ordering_rules, [_ | updates]} = Lib.read_lines()
    |> Enum.split_while(fn line -> line != "" end)

    should_go_after = parse_rules(ordering_rules)

    updates
    |> Enum.map(&parse_update/1)
    |> Enum.filter(fn update -> not follows_rules?(update, should_go_after) end)
    |> Enum.map(&topo_sort(should_go_after, &1))
    |> Enum.map(&middle_element/1)
    |> Enum.sum()
    |> IO.inspect(charlists: :as_lists)
  end

  def parse_update(update_line),
    do:
      String.split(update_line, ",")
      |> Enum.map(&Lib.parse_int/1)

  def follows_rules?(update, rules, met_before \\ [])
  def follows_rules?([], _, _), do: true
  def follows_rules?([page | updates], rules, met_before) do
    should_go_after = Map.get(rules, page, MapSet.new())
    none?(met_before, &(MapSet.member?(should_go_after, &1))) and \
      follows_rules?(updates, rules, [page | met_before])
  end

  def none?([], _), do: true
  def none?([item | rest], predicate),
    do: not predicate.(item) and none?(rest, predicate)

  def parse_rules(lines) do
    Enum.map(lines, &String.split(&1, "|"))
    |> Enum.map(fn rule -> Enum.map(rule, &Lib.parse_int/1) end)
    |> Enum.reduce(
      Map.new(),
      fn [prev, succ], map ->
        Map.update(map, prev, MapSet.new([succ]), &MapSet.put(&1, succ))
      end
    )
  end

  def middle_element(list), do: middle_element(list, list)
  def middle_element([_], [middle | _]), do: middle
  def middle_element([], [middle | _]), do: middle
  def middle_element([_, _ | fast], [_ | slow]), do: middle_element(fast, slow)

  def topo_sort(graph, list) do
    # Convert the list into a set for quick membership checks
    list_set = MapSet.new(list)

    # Filter the graph to only include nodes and dependencies from the list
    relevant_graph = 
      Enum.reduce(graph, %{}, fn {node, neighbors}, acc ->
        if MapSet.member?(list_set, node) do
          Map.put(acc, node, Enum.filter(neighbors, &MapSet.member?(list_set, &1)))
        else
          acc
        end
      end)

    # Perform topological sort with filtered graph
    {sorted, _visited} =
      Enum.reduce(list, {[], MapSet.new()}, fn node, {acc, visited} ->
        dfs(node, relevant_graph, acc, visited, list_set)
      end)

    sorted
  end

  defp dfs(node, graph, sorted, visited, list_set) do
    if MapSet.member?(visited, node) do
      {sorted, visited}
    else
      {new_sorted, new_visited} =
        Enum.reduce(Map.get(graph, node, []), {sorted, MapSet.put(visited, node)}, fn neighbor, {acc, vis} ->
          dfs(neighbor, graph, acc, vis, list_set)
        end)

      {[node | new_sorted], new_visited}
    end
  end
end
