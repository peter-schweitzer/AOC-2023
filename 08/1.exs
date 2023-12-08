#!/bin/elixir

# {:ok, text} = File.read("test.txt")
# {:ok, text} = File.read("test2.txt")
{:ok, text} = File.read("input.txt")

[directions | [raw_node_section]] = text |> String.split("\n\n")

defmodule N do
  def parse(node_description, map) do
    [name | [next_description]] = node_description |> String.split(" = ")
    [left | [right]] = next_description |> String.replace(["(", ",", ")"], "") |> String.split(" ")
    Map.put(map, name, %{l: left, r: right})
  end

  def next_dir(dirs, idx) do
    case String.at(dirs, rem(idx, String.length(dirs))) do
      "L" -> :l
      "R" -> :r
    end
  end

  def step(nodes, dirs, cur_node, idx) do
    next_node = nodes[cur_node][next_dir(dirs, idx)]
    case next_node do
      "ZZZ" -> idx+1
      _ -> step(nodes, dirs, next_node, idx+1)
    end
  end
end

N.step(raw_node_section |> String.split("\n") |> Enum.reduce(%{}, &N.parse(&1, &2)), directions, "AAA", 0) |> IO.inspect
