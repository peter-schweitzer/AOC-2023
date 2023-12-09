#!/bin/elixir

# {:ok, text} = File.read("test.txt")
{:ok, text} = File.read("input.txt")

value_histories = for line <- text |> String.split("\n"), do: line |> String.split(" ") |> Enum.map(&String.to_integer(&1)) |> Enum.reverse

value_histories |> IO.inspect

defmodule Extrapolate do
  def derive(history) do
    change = for i <- 0..(Enum.count(history)-2), reduce: [] do changes ->
      [Enum.at(history, i+1) - Enum.at(history, i) | changes]
    end |> Enum.reverse |> IO.inspect
    case Enum.all?(change, &(&1===0)) do
      true -> 0
      false -> Enum.at(change, -1) + derive(change)
    end
  end
end


for value_history <- value_histories do
  (Enum.at(value_history, -1) + (value_history |> Extrapolate.derive)) |> IO.inspect
end |> Enum.sum |> IO.inspect
