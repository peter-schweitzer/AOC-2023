{:ok, text} = File.read("input.txt")

defmodule FindNumber do
  def first(<<c::utf8, _::binary>>) when c in ?0..?9 do
    List.to_string([c])
  end
  def first (<<?o, ?n, ?e, _::binary>>) do
    "1"
  end
  def first (<<?t, ?w, ?o, _::binary>>) do
   "2"
  end
  def first (<<?t, ?h, ?r, ?e, ?e, _::binary>>) do
   "3"
  end
  def first (<<?f, ?o, ?u, ?r, _::binary>>) do
   "4"
  end
  def first (<<?f, ?i, ?v, ?e, _::binary>>) do
   "5"
  end
  def first (<<?s, ?i, ?x, _::binary>>) do
   "6"
  end
  def first (<<?s, ?e, ?v, ?e, ?n, _::binary>>) do
   "7"
  end
  def first (<<?e, ?i, ?g, ?h, ?t, _::binary>>) do
   "8"
  end
  def first (<<?n, ?i, ?n, ?e, _::binary>>) do
   "9"
  end
  def first(<<_::utf8, rest::binary>>) do
    first(rest)
  end

    def last(<<c::utf8, _::binary>>) when c in ?0..?9 do
    List.to_string([c])
  end
  def last (<<?e, ?n, ?o, _::binary>>) do
    "1"
  end
  def last (<<?o, ?w, ?t, _::binary>>) do
   "2"
  end
  def last (<<?e, ?e, ?r, ?h, ?t, _::binary>>) do
   "3"
  end
  def last (<<?r, ?u, ?o, ?f, _::binary>>) do
   "4"
  end
  def last (<<?e, ?v, ?i, ?f, _::binary>>) do
   "5"
  end
  def last (<<?x, ?i, ?s, _::binary>>) do
   "6"
  end
  def last (<<?n, ?e, ?v, ?e, ?s, _::binary>>) do
   "7"
  end
  def last (<<?t, ?h, ?g, ?i, ?e, _::binary>>) do
   "8"
  end
  def last (<<?e, ?n, ?i, ?n, _::binary>>) do
   "9"
  end
  def last(<<_::utf8, rest::binary>>) do
    last(rest)
  end
end


for line <- String.split(text, "\n"), reduce: 0 do x ->
  first = FindNumber.first(line)
  last = String.reverse(line) |> FindNumber.last
  x + String.to_integer(first <> last)
end |> IO.puts
