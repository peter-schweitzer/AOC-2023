#!/bin/elixir

# {:ok, text} = File.read("test.txt")
{:ok, text} = File.read("input.txt")

char_map = text |> String.split("\n")
  |> Enum.map(&String.graphemes(&1))
  |> IO.inspect

rows_to_expand = char_map |> Enum.with_index
  |> Enum.filter(fn {line, _} -> line |> Enum.all?(&(&1 === ".")) end)
  |> Enum.map(&elem(&1, 1))

cols_to_expand = for line <- char_map, reduce: Enum.at(char_map, 0) |> Enum.map(fn _ -> true end) do cols ->
  for {c, i} <- line |> Enum.with_index, do: c === "." and Enum.at(cols, i)
end |> Enum.with_index |> Enum.filter(&elem(&1, 0)) |> Enum.map(&elem(&1, 1))

galaxy_positions = for {row, y} <- char_map |> Enum.with_index, reduce: [] do galaxies ->
  row_gs = row |> Enum.with_index |> Enum.filter(&(elem(&1, 0) === "#")) |> Enum.map(&elem(&1, 1))
  for x <- row_gs, reduce: galaxies do gs -> [{x, y} | gs] end
end

defmodule Dist do
  def calc(g, _, _) when g === [], do: 0

  def calc(galaxies, exp_rows, exp_cols) do
    [{x1, y1} | remaining_galaxies] = galaxies
    dist = for {x2, y2} <- remaining_galaxies, reduce: 0 do s ->
      {x_min, x_max, y_min, y_max} = {min(x1, x2), max(x1, x2), min(y1, y2), max(y1, y2)}
      exp_rows_count = exp_rows |> Enum.filter(&(&1 in y_min..y_max)) |> Enum.count
      exp_cols_count = exp_cols |> Enum.filter(&(&1 in x_min..x_max)) |> Enum.count
      s + abs(x2-x1) + abs(y2-y1) + (exp_rows_count + exp_cols_count) * (1_000_000-1)
    end
    dist + calc(remaining_galaxies, exp_rows, exp_cols)
  end
end

Dist.calc(galaxy_positions, rows_to_expand, cols_to_expand) |> IO.inspect
