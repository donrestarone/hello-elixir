defmodule Cards do

  @moduledoc """
    Provides methods for creating & handling a deck of cards
  """

  @doc """
    creates a deck of cards and returns them in an array
  """
  def create_deck do 
    values = ["Ace", "Two", "Three", "Four", "Five"]
    suits = ["Spades", "Clubs", "Hearts", "Diamonds"]

    for suit <- suits, value <- values do 
      "#{value} of #{suit}"
    end
  end


  @doc """
    when an array of cards are passed in, returns a shuffled deck
  """

  def shuffle(deck)do
    Enum.shuffle(deck)
  end


  @doc """
    when a deck of cards (array) and a card name is passed in, returns true if the card is in the collection
  """
 
  def contains?(deck, card_name) do
    Enum.member?(deck, card_name)
  end

  @doc """
    when a deck & hand size is provided, returns a hand of cards
  ## Examples
        iex> deck = Cards.create_deck
        iex> {hand, deck} = Cards.deal(deck, 1)
        iex> hand
        ["Ace of Spades"]
  """

  def deal(deck, size) do 
    {hand, _rest} = Enum.split(deck, size)
    hand
  end

  @doc """
    when a deck & file name are specified, saves the deck to disk
  """

  def save(deck, filename) do
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary )
  end

  @doc """
    loads a deck of cards from the disk
  """

  def load(filename) do
  # the return value of File.read is a tuple, which is ok or error. 
    case File.read(filename) do 
    # comparison and assignment in one operation
    # for the success tuple/case, there is the ok & a binary
      {:ok, binary} -> :erlang.binary_to_term(binary)
      # for the failure tuple/case, there is the error & a reason/message
      {:error, reason} -> "File not found #{reason}"
    end
  end

  @doc """
    creates a new deck, shuffles it and deals a hand from that deck when hand size is specified
  """

  def create_hand(hand_size) do
  # the first argument for deal(deck, size) will be automatically passed by the pipe operator
    Cards.create_deck |> Cards.shuffle |> Cards.deal(hand_size)
  end
end
# iex -S mix
