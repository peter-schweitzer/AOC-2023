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

  def step(nodes, dirs, cur_node, idx\\0) do
    next_node = nodes[cur_node][next_dir(dirs, idx)]
    case String.at(next_node, 2) do
      "Z" -> idx+1
      _ -> step(nodes, dirs, next_node, idx+1)
    end
  end

  def lcm(0, 0), do: 0
	def lcm(a, b), do: (a*b)/gcd(a,b)
end

node_descriptions = raw_node_section |> String.split("\n")

nodes = node_descriptions |> Enum.reduce(%{}, &N.parse(&1, &2))

start_nodes = nodes |> Map.keys |> Enum.filter(&(String.at(&1, 2) == "A"))

l = for start_node <- start_nodes do
  N.step(nodes, directions, start_node)
end
l |> IO.inspect
