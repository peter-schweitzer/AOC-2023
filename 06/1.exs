#!/bin/elixir

# {:ok, text} = File.read("test.txt")
{:ok, text} = File.read("input.txt")

[times | [distances]] = text |> String.split("\n") |> Enum.map(fn l -> l |> String.split(~r"\W+") |> tl |> Enum.map(&String.to_integer(&1)) end) |> IO.inspect()

td_pairs = Enum.zip(times, distances) |> IO.inspect

for {t, d} <- td_pairs, reduce: 1 do acc ->
  for i <- 1..(t-1), reduce: 0 do x ->
    cond  do
        i*(t-i) > d -> x+1
        true -> x
    end
  end * acc
end |> IO.inspect()