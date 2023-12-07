#!/bin/elixir

# {:ok, text} = File.read("test.txt")
{:ok, text} = File.read("input.txt")

defmodule Cards do
  def parseType(hand) do
    card_map = hand |> String.graphemes |> Enum.frequencies
    {pairs, trips, quads, five} = for {card, num} <- card_map, reduce: {0, 0, 0, 0} do {p, t, q, f} ->
      case num do
        2 -> {p+1, t, q, f}
        3 -> {p, t+1, q, f}
        4 -> {p, t, q+1, f}
        5 -> {p, t, q, f+1}
        _ -> {p, t, q, f}
      end
    end

    cond do
      five == 1 -> 6
      quads == 1 -> 5
      trips == 1 -> case pairs do
          1 -> 4
          0 -> 3
        end
      true -> pairs
    end
  end

  def cmp_same_type(hand1, hand2) do
    face_map = %{"A" => 12, "K" => 11, "Q" => 10, "J" => 9, "T" => 8, "9" => 7, "8" => 6, "7" => 5, "6" => 4, "5" => 3, "4" => 2, "3" => 1, "2" => 0}
    for i <- 0..4, reduce: nil do ret ->
      val1 = face_map[hand1|>String.at(i)] |> IO.inspect
      val2 = face_map[hand2|>String.at(i)] |> IO.inspect
      "ret:" |> IO.inspect
      ret |> IO.inspect
      case ret do
        nil -> cond do
            val1 === val2 -> nil
            true -> val1 <= val2
          end
        _ -> ret
      end
    end |> IO.inspect()
  end

  def cmp(hand1, hand2) do
    type1 = parseType(hand1)
    type2 = parseType(hand2)
    cond do
      type1 < type2 -> true
      type1 > type2 -> false
      true -> cmp_same_type(hand1, hand2)
    end
  end
end

hands_with_bets = text |> String.split("\n") |> Enum.map(fn l -> l |> String.split(" ") end) |> Enum.map(fn [hand|[bet]] -> {hand, String.to_integer(bet)} end) |> IO.inspect |> Enum.sort(&Cards.cmp(elem(&1, 0), elem(&2, 0)))

for {{_, bet}, idx} <- hands_with_bets |> Enum.with_index, reduce: 0 do acc ->
  acc + bet * (idx+1)
end |> IO.inspect


