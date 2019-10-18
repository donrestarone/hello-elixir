defmodule CardsTest do
  use ExUnit.Case
  # this will run tests that are annotated by ## Examples in cards.ex
  doctest Cards

  test "create_deck makes 20 cards" do 
    assert(Cards.create_deck |> length == 20)
  end

  test "shuffling a deck randomizes it" do
    deck = Cards.create_deck
    assert(deck != Cards.shuffle(deck))
  end
end
