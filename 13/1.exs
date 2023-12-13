#!/bin/elixir

# {:ok, text} = File.read("test.txt")
{:ok, text} = File.read("input.txt")


defmodule Symmetry do
  def validate(list, idx_l, idx_r) when idx_l < 0 or idx_r === length(list), do: true
  def validate(list, idx_l, idx_r), do: Enum.at(list, idx_l) === Enum.at(list, idx_r) and validate(list, idx_l-1, idx_r+1)

  def find(map) do
    rows = map |> String.split("\n")
    r = rows |>Enum.with_index |> Enum.filter(fn {_, idx} -> length(rows)-idx > 1 and validate(rows, idx, idx+1)end) |> Enum.map(&elem(&1, 1)) |> List.first
    if r !== nil do
      (r+1)*100
    else
      cols = rows |> Enum.map(&String.graphemes(&1)) |> List.zip |> Enum.map(&(Tuple.to_list(&1) |> Enum.join))
      c = cols |> Enum.with_index |> Enum.filter(fn {_, idx} -> length(cols)-idx > 1 and validate(cols, idx, idx+1)end) |> Enum.map(&elem(&1, 1)) |> List.first
      c + 1
    end
  end
end

text |> String.split("\n\n") |> Enum.map(&Symmetry.find(&1)) |> Enum.sum |> IO.inspect
