defmodule War do
  @moduledoc """
    Documentation for `War`.
  """

  @doc """
    Function stub for deal/1 is given below. Feel free to add
    as many additional helper functions as you want.

    The tests for the deal function can be found in test/war_test.exs.
    You can add your five test cases to this file.

    Run the tester by executing 'mix test' from the war directory
    (the one containing mix.exs)
  """


  #This is the main function that deals the deck of integers to player 1 and 2. This function applies
  #the ace rank to the deck and then deals it to each player. The variable winner is then calling the game
  #which returns the winning deck. The winning deck is then returned after removing the ace rank.
  def deal(shuf) do
    deck =
      shuf
      |> Enum.map(&apply_ace/1)
      |> Enum.reverse()

    {p1,p2} = deal_deck(deck)
    winner = play_game(p1,p2)
    winning_deck = winner
                  |> Enum.map(&remove_ace/1)
    winning_deck
  end



  #The deal_deck funtion takes in the deck of 52 integers, and sorts them by taking every other number
  #and assigning it to player1 and using drop every to assign the other numbers to player2 deck.
  def deal_deck(deck) do
    {Enum.take_every(deck, 2), Enum.drop_every(deck, 2)}
  end


  #This function simulates the main game of war that will run taking in player 1's deck, player 2's deck
  #and tied initlailzed to an empty deck as it will not be used until war occurs.
  defp play_game(p1, p2, tied \\ [])

  #This clause handles if p2 is the only one left with cards and assigns anything stored in tied to them.
  defp play_game([], p2, tied) do
    case p2 do
      [] -> Enum.sort(tied, :desc)
    _ -> p2 ++ Enum.sort(tied, :desc)
    end
  end

  #This clause handles if p1 is the only one left with cards and assigns anything stored in tied to them.
  defp play_game(p1, [], tied) do
    case p1 do
      [] -> Enum.sort(tied, :desc)
      _ -> p1 ++ Enum.sort(tied, :desc)
    end
  end


  #This function is a recursive call of the normal game turn. The two decks are taken in as input, and split with
  #the head being the card drawn and tail being the rest of the players deck. Both drawn cards are then assigned in a
  #temp variable that stores them so it can be added to the winners deck based of the case do statements which compare
  #the drawn cards based of rank. If the drawn cards are equal the war case occurs in which we check for empty decks (meaning war cannot occur)
  #and then split the two decks with our new face down card and call play_game again. This will take the face downs compare them in
  #our case do and whoever has the higher rank gets the face down cards plus the ones stored in tied when war occurred.
  #The game will then continue until the clauses made above occur where one of the players has an empty deck making the other
  #the winner!

  defp play_game([card1| deck1], [card2 | deck2], tied) do
    cards = Enum.sort([card1, card2] ++ tied, :desc)

    case card1 > card2 do
      true ->
        play_game(deck1 ++ cards, deck2)

      false ->
        case card1 < card2 do
          true ->
            play_game(deck1, deck2 ++ cards)

          false ->
            case {deck1,deck2} do
              {[], _} ->
                deck2 ++ Enum.sort(cards, :desc)

              {_,[]} ->
                deck1 ++ Enum.sort(cards, :desc)

              {[down1 | rest1], [down2 | rest2]} ->
                play_game(rest1, rest2, cards ++ [down1,down2])
            end
        end
    end
  end

  #This function finds all 1's in the deck and turns them into 14 as they are actually an Ace
  defp apply_ace(card) do
    if card == 1 do
      14
    else
      card
    end
  end

  #This function finds all cards in the deck that are 14 and turns them back into 1 in order to return the winning deck
  defp remove_ace(card) do
    if card == 14 do
      1
    else
      card
    end
  end
end
