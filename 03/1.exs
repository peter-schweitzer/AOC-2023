# {:ok, text} = File.read("test.txt")
{:ok, text} = File.read("input.txt")

lines = text |> String.split("\n")

for {line, i} <- lines |> Enum.with_index, reduce: 0 do acc ->
  all_nums = Regex.scan(~r"\d+", line, return: :index) |> Enum.map(&hd &1)
  valid_nums = all_nums |> Enum.filter( fn {s, len} ->
      ln_slc = lines |> Enum.slice(max(i - 1, 0)..i+1)
      map_ln_slc = ln_slc |> Enum.map(&String.slice(&1, max(s-1, 0)..s+len)) |> Enum.map(&Regex.replace(~r"[\.0-9]", &1, ""))
      filtered = map_ln_slc |> Enum.filter(&(String.length(&1) > 0))
      filtered |> Enum.count > 0
    end)
  num_sum = valid_nums |> Enum.map(fn {s, e} -> String.slice(line, s, e) |> String.to_integer end) |> Enum.sum
  acc + num_sum
end |> IO.puts
