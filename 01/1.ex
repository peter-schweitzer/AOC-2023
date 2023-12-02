{:ok, text} = File.read("input.txt")

defmodule FindNumber do
  def first(<<c::utf8, _::binary>>) when c in ?0..?9 do
    List.to_string([c])
  end

  def first(<<_::utf8, rest::binary>>) do
    first(rest)
  end
end

for line <- String.split(text, "\n"), reduce: 0 do x ->
  first = FindNumber.first(line)
  last = String.reverse(line) |> FindNumber.first
  x + String.to_integer(first <> last)
end |> IO.puts
