#!/bin/elixir

# {:ok, text} = File.read("test.txt")
{:ok, text} = File.read("input.txt")

defmodule Cards do
  def parseType(hand) do
    card_map = hand |> String.graphemes |> Enum.frequencies
    num_jokers = case card_map["J"] do
         nil -> 0
         _ -> card_map["J"] 
      end

    {pairs, trips, quads, five} = for {card, num} <- card_map, reduce: {0, 0, 0, 0} do {p, t, q, f} ->
      case card do
        "J" -> {p, t, q, f}
        _ -> case num do
            2 -> {p+1, t, q, f}
            3 -> {p, t+1, q, f}
            4 -> {p, t, q+1, f}
            5 -> {p, t, q, f+1}
            _ -> {p, t, q, f}
          end
      end
    end

    cond do
      five == 1 -> 6
      quads == 1 -> 5 + num_jokers
      trips == 1 -> min(3 + pairs + 2 * num_jokers, 6)
      pairs > 0 -> min(pairs + 2 * num_jokers, 6)
      num_jokers < 2 -> num_jokers
      num_jokers > 3 -> 6
      true -> 2*num_jokers-1
    end
  end

  def cmp_same_type(hand1, hand2) do
    face_map = %{"A" => 12, "K" => 11, "Q" => 10, "T" => 9, "9" => 8, "8" => 7, "7" => 6, "6" => 5, "5" => 4, "4" => 3, "3" => 2, "2" => 1, "J" => 0}
    for i <- 0..4, reduce: nil do ret ->
      val1 = face_map[hand1|>String.at(i)]
      val2 = face_map[hand2|>String.at(i)]
      case ret do
        nil -> cond do
            val1 === val2 -> nil
            true -> val1 < val2
          end
        _ -> ret
      end
    end
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

hands_with_bets = text |> String.split("\n") |> Enum.map(fn l -> l |> String.split(" ") end) |> Enum.map(fn [hand|[bet]] -> {hand, String.to_integer(bet)} end) |> Enum.sort(&Cards.cmp(elem(&1, 0), elem(&2, 0)))

for {{h, bet}, idx} <- hands_with_bets |> Enum.with_index, reduce: 0 do acc ->
  acc + bet * (idx+1)
end |> IO.inspect
