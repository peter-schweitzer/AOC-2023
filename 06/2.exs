#!/bin/elixir

# {:ok, text} = File.read("test.txt")
{:ok, text} = File.read("input.txt")

[t | [d]] = text |> String.split("\n") |> Enum.map(fn l -> l |> String.split(~r"\W+") |> tl |> Enum.reduce("", fn str, acc -> "#{acc}#{str}" end) |> String.to_integer end) |> IO.inspect()

for i <- 1..(t-1), reduce: 0 do x ->
  cond  do
    i*(t-i) > d -> x+1
    true -> x
  end
end |> IO.inspect()