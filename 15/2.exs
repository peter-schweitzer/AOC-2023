#!/bin/elixir

defmodule HASH do
  def calc(chunk) do
    for <<c::utf8>> <- chunk |> String.graphemes, reduce: 0 do hash -> rem((hash + c) * 17, 256) end
  end

  def add({order, kv}, id, v) do
    {
      case Map.has_key?(kv, id) do
        true -> order
        false -> order ++ [id]
      end,
      Map.put(kv, id, v)
    }
  end

  def rm({order, kv}, id) do
    {order, kv, id}
    idx = order |> Enum.find_index(&(&1 === id))
    new_order = List.delete_at(order, idx);
    new_kv = Map.delete(kv, id);
    {new_order, new_kv}
  end
end

defmodule Main do
  def main do
    # {:ok, text} = File.read("test.txt")
    {:ok, text} = File.read("input.txt")
    chunks = text |> String.trim("\n") |> String.split(",")

    populated_map = for chunk <- chunks, reduce: (for _ <- 0..255, do: {[], %{}}) do map ->
      [id_str, op_str] = Regex.run(~r"(\w+)=?(\d|-)", chunk) |> tl
      id = id_str |> String.to_atom
      hash = id_str |> HASH.calc

      bucket = map |> Enum.at(hash)
      new_bucket = cond do
        op_str !== "-" -> HASH.add(bucket, id , op_str |> String.to_integer)
        Map.has_key?(elem(bucket, 1), id) -> HASH.rm(bucket, id)
        true -> bucket
      end

      List.replace_at(map, hash, new_bucket)
    end

    # let acc = 0;
    # for (let i = 0; i < map.length; i++) {
    #   const b = map[i];
    #   for (let j = 0; j < b.order.length; j++) {
    #     const k = b.order[j];
    #     acc += (i + 1) * (j + 1) * b.kv[k];
    #   }
    # }
    for {{order, kv}, i} <- populated_map |> Enum.with_index, reduce: 0 do sum ->
      box_sum = for {k, j} <- order |> Enum.with_index, reduce: 0 do acc ->
        v = Map.get(kv, k)
        acc + (j + 1) * v
      end * (i + 1)
      sum + box_sum
    end
  end
end

Main.main |> IO.inspect
