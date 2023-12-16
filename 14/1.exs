#!/bin/elixir

# {:ok, text} = File.read("test.txt")
{:ok, text} = File.read("input.txt")

rows = text |> String.split("\n")
cols = rows |> Enum.map(&String.graphemes(&1)) |> List.zip |> Enum.map(&(Tuple.to_list(&1)))

row_len = length(rows)

for col <- cols do
  for {c, i} <- col |> Enum.with_index, reduce: {[], 0} do {rocks, idx} ->
    case (c) do
      "." -> {rocks, idx}
      "#" -> {rocks, i+1}
      "O" -> {[row_len-idx | rocks], idx+1}
    end
  end |> elem(0) |> Enum.sum
end |> Enum.sum |> IO.inspect
