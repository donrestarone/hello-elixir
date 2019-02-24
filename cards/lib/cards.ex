defmodule Cards do

  def create_deck do 
    values = ["Ace", "Two", "Three"]
    suits = ["Spades", "Clubs", "Hearts", "Diamonds"]

    # for each suit in array of suits, behaves like .map(())
    for suit <- suits do 
      suit
    end 
  end

  def shuffle(deck)do
    Enum.shuffle(deck)
  end

  def contains?(deck, hand) do
    Enum.member?(deck, hand)
  end
end
# iex -S mix
# Cards.hello()