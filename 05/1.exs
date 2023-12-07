#!/bin/elixir

# {:ok, text} = File.read("test.txt")
{:ok, text} = File.read("input.txt")

[raw_seed_section | raw_map_section] = text |> String.split("\n\n")

seeds = raw_seed_section |> String.split(" ") |> tl |> Enum.map(&String.to_integer &1)

maps = raw_map_section
  |> Enum.map(fn raw_map -> raw_map
    |> String.split("\n")
    |> tl
    |> Enum.map(fn map_row -> map_row
      |> String.split(" ")
      |> Enum.map(&String.to_integer(&1))
    end)
  end)


for mapped_seed <- seeds |> Enum.map(fn seed ->
   maps |> Enum.reduce(seed,
   fn map, s ->
      map |> Enum.reduce(s,
      fn [dest | [orig | [len]]], a ->
        case s in orig..(orig+len-1) do
          true -> a + dest - orig
          false -> a
        end
      end)
   end)
  end), reduce: 0 do minimum ->
  case minimum do
    0 -> mapped_seed
    _ -> min(mapped_seed, minimum)
  end
end |> IO.puts
