#!/bin/elixir

# {:ok, text} = File.read("test.txt")
{:ok, text} = File.read("input.txt")

char_map = text |> String.split("\n") |> Enum.map(&String.graphemes(&1)) |> IO.inspect

rows_to_double = for {line, idx} <- char_map |> Enum.with_index, reduce: [] do rows ->
  case line |> Enum.all?(&(&1 === ".")) do
    true -> [idx | rows]
    false -> rows
  end
end |> Enum.reverse

columns_to_double = for line <- char_map, reduce: Enum.at(char_map, 0) |> Enum.map(fn _ -> true end) do cols ->
  for {c, i} <- line |> Enum.with_index do
    c === "." and Enum.at(cols, i)
  end
end |> Enum.with_index |> Enum.filter(&elem(&1, 0)) |> Enum.map(&elem(&1, 1))

doubled_rows_map = for {row, idx} <- char_map |> Enum.with_index, reduce: [] do expanded_rows ->
  case idx in rows_to_double do
    true -> [row, row | expanded_rows]
    false -> [row | expanded_rows]
  end
end

expanded_map = for {idx, offset} <- columns_to_double |> Enum.with_index, reduce: doubled_rows_map do m ->
  for row <- m do
    {h, t} = Enum.split(row, idx+offset)
    h ++ ["." | t]
  end
end

expanded_map |> IO.inspect

galaxy_positions = for {row, y} <- expanded_map |> Enum.with_index, reduce: [] do galaxies ->
  row_gs = row |> Enum.with_index |> Enum.filter(&(elem(&1, 0) === "#")) |> Enum.map(&elem(&1, 1))
  for x <- row_gs, reduce: galaxies do gs ->
    [{x, y} | gs]
  end
end


defmodule Dist do
  def calc(g) when g === [] do
    0
  end
  def calc(galaxies) do
    [{x1, y1} | remaining_galaxies] = galaxies
    dist = for {x2, y2} <- remaining_galaxies, reduce: 0 do s ->
      s + abs(x2-x1) + abs(y2-y1)
    end
    dist + calc(remaining_galaxies)
  end
end

Dist.calc(galaxy_positions |> IO.inspect) |> IO.inspect
