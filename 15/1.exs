#!/bin/elixir

# {:ok, text} = File.read("test.txt")
{:ok, text} = File.read("input.txt")

chunks = text |> String.trim("\n") |> String.split(",") |> Enum.map(&String.graphemes(&1)) |> IO.inspect

defmodule HASH do
  def calc(chunk) do
    for <<c::utf8>> <- chunk, reduce: 0 do hash -> rem((hash + c) * 17, 256) end
  end
end

chunks |> Enum.map(&HASH.calc(&1)) |> Enum.sum |> IO.inspect
