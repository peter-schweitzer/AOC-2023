#!/bin/elixir

# {:ok, text} = File.read("test.txt")
{:ok, text} = File.read("input.txt")

defmodule Pipes do
  def at(map, x, y) do
    map |> Enum.at(y) |> Enum.at(x)
  end
  def at(map, {x, y, _}), do: at(map, x, y)

  def find_start(lines, idx\\0) do
    line = lines |> Enum.at(idx)
    case line |> String.split("S") |> Enum.at(0) do
      ^line -> find_start(lines, idx+1)
      x -> {String.length(x), idx}
    end

  end

  def next_dir(map, {x, y, dir}) do
    "#{at(map, x, y)} with dir #{dir}" |> IO.inspect
    case at(map, x, y) do
      "F" -> case dir do
          0 -> 1
          _ -> 2
        end
      "7" -> case dir do
          0 -> 3
          _ -> 2
        end
      "L" -> case dir do
          2 -> 1
          _ -> 0
        end
      "J" -> case dir do
          1 -> 0
          _ -> 3
        end
      "S" -> cond do
          at(map, x, max(0, y-1)) in ["|", "F", "7"] -> 0
          at(map, min(x+1, (map|>Enum.at(0)|>Enum.count)-1), y) in ["-", "J", "7"] -> 1
          at(map, x, min(y+1, (map|>Enum.count)-1)) in ["|", "L", "J"] -> 2
          at(map, max(0, x-1), y) in ["-", "L", "F"] -> 3
        end
      _ -> dir
    end |> IO.inspect
  end

  def next_pos(map, {x, y, dir}) do
    case next_dir(map, {x, y, dir}) do
      0 -> {x, y-1, 0}
      1 -> {x+1, y, 1}
      2 -> {x, y+1, 2}
      3 -> {x-1, y, 3}
    end
  end

  def walk(map, pos, idx\\1) do
    next = next_pos(map, pos)
    case at(map, next) do
      "S" -> idx |> IO.inspect
      _ -> walk(map, next, idx + 1)
    end
  end
end

lines = text |> String.split("\n")
map = lines |> Enum.map(&(&1 |> String.split("") |> Enum.slice(1, String.length(&1))))

{x, y} = Pipes.find_start(lines) |> IO.inspect

Pipes.walk(map, {x, y, nil}) / 2 |> floor |> IO.inspect
