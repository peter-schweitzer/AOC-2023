# {:ok, text} = File.read("test.txt")
{:ok, text} = File.read("input.txt")

text |> String.split("\n") |> Enum.reduce(0, fn (line, acc) ->
  [_ | all_numbers] = line |> String.split([":", "|"], trim: true)
  [wining | [found]] = all_numbers |> Enum.map(&String.split(&1, ~r"\W+", trim: true))
  acc + case Enum.filter(found, &(&1 in wining)) |> Enum.count do
    0 -> 0
    c -> :math.pow(2, c-1)
  end
end) |> trunc |> IO.inspect
