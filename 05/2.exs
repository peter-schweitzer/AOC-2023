#!/bin/elixir

# {:ok, text} = File.read("test.txt")
{:ok, text} = File.read("input.txt")

[raw_seed_section | raw_map_section] = text |> String.split("\n\n")


raw_seed_ranges = raw_seed_section |> String.split(" ") |> tl |> Enum.map(&String.to_integer &1)

seed_ranges = for i <- 0..(Enum.count(raw_seed_ranges)-1), reduce: [] do sl ->
  case rem(i, 2) == 0 do
    true -> [s | [l]] = raw_seed_ranges|> Enum.slice(i..i+1)
      [{s, (s+l-1)} | sl]
    false -> sl
  end
end

maps = raw_map_section
  |> Enum.map(fn raw_map -> raw_map
    |> String.split("\n")
    |> tl
    |> Enum.map(fn row ->
        values = row |> String.split(" ") |> Enum.map(&String.to_integer(&1))
        [dest | [orig | [len]]] = values
        {orig, orig + len - 1, dest - orig}
      end)
  end)

defmodule Mapper do
  def seed_range(s, map_rows) when map_rows == [], do: [s]

  def seed_range({s_s, s_e}, map_rows) do
    [{m_s, m_e, m_o } | rem_rows] = map_rows
    cond do
      s_s < m_s -> [{s_s, m_s-1} | seed_range({m_s, s_e}, rem_rows)]
      s_e > m_e -> [{s_s+m_o, m_e+m_o} | seed_range({m_e+1, s_e}, rem_rows)]
      true -> [{s_s + m_o, s_e + m_o}]
    end
  end
end

mapped_ranges = for {{seed_s, seed_e}, idx} <- seed_ranges |> Enum.with_index(&({&1, &2})) do
  mapped_seed_range = for map <- maps, reduce: [{seed_s, seed_e}] do seed_range ->
    valid_map_rows = map |> Enum.filter(fn {map_s, map_e, _} -> map_s <= seed_e and map_e >= seed_s end) |> Enum.sort_by(&elem &1, 0)
    seed_range |> Enum.flat_map(&Mapper.seed_range(&1, valid_map_rows))
  end
  {mapped_seed_range, idx}
end

lowest_range_idx = for {sub_range, idx} <- mapped_ranges do
  min_sub_range = sub_range |> Enum.min_by(&elem &1, 0)
  {min_sub_range, idx}
end |> Enum.min_by(fn e -> elem(e, 0) |> elem(0) end) |> elem(1)

lowest_range = Enum.at(seed_ranges, lowest_range_idx) |> IO.inspect


