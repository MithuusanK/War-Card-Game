module War (deal) where

import Data.List(sort)

{--
Function stub(s) with type signatures for you to fill in are given below. 
Feel free to add as many additional helper functions as you want. 

The tests for these functions can be found in src/TestSuite.hs. 
You are encouraged to add your own tests in addition to those provided.

Run the tester by executing 'cabal test' from the war directory 
(the one containing war.cabal)
--}


-- This is the main function that deals the deck of integers to player 1 and 2. This function applies
-- the ace weight to the deck and then deals it to each player. The variable winner is then calling the game
-- which returns the winning deck. The winning deck is then returned after removing the ace weight.
deal :: [Int] -> [Int]
deal shuf =
  let deck = reverse $ map applyAce shuf
      (p1, p2) = dealDeck deck
      winner = playGame p1 p2 []
      winningDeck = map removeAce winner
  in winningDeck


-- The deal_deck function takes in the deck of 52 integers, and sorts them by taking every other number
-- and assigning it to player1 and using drop every to assign the other numbers to player2 deck.
dealDeck :: [Int] -> ([Int], [Int])
dealDeck deck = (takeEvery 2 deck, dropEvery 2 deck)

-- Helper function to apply ace card weight
applyAce :: Int -> Int
applyAce card = if card == 1 then 14 else card

-- Helper function to remove ace card weight
removeAce :: Int -> Int
removeAce card = if card == 14 then 1 else card

-- Helper functions that are used to hand out the cards to each players deck
takeEvery :: Int -> [a] -> [a]
takeEvery n = map snd . filter (\(i,_) -> i `mod` n == n-1) . zip [0..]

dropEvery :: Int -> [a] -> [a]
dropEvery n = map snd. filter (\(i,_) -> i `mod` n /= n-1) . zip [0..]


-- This function simulates the main game of war that will run taking in player 1's deck, player 2's deck
-- and tied which will not be used until war occurs. 
playGame :: [Int] -> [Int] -> [Int] -> [Int]
-- In this case player 1 deck is empty and all cards are sorted and given to player 2 
playGame [] p2 tied = case p2 of
                          [] -> reverse (sort tied)
                          _  -> p2 ++ reverse (sort tied)
-- In this case player 2 deck is empty and all cards are sorted and given to player 1
playGame p1 [] tied = case p1 of
                          [] -> reverse (sort tied)
                          _  -> p1 ++ reverse (sort tied)
-- This is the normal turn in which the deck is split in order to get the cards at play and the rest of the decks
-- Cards stores the cards at player and the person with the greater card rank takes cards and it gets added to there deck
-- If the cards are equal the decks are check in order to ensure they aren't empty and can play war. Once so the decks are then split
-- with the new facedown cards and then the play game function is called again with the face down cards and tied cards beinf stored in tied 
playGame (card1 : deck1) (card2 : deck2) tied =
  let cards = reverse (sort (card1 : card2 : tied))
  in (if card1 > card2 then playGame (deck1 ++ cards) deck2 [] else (if card1 < card2 then playGame deck1 (deck2 ++ cards) [] else (case (deck1, deck2) of
              ([], _) -> deck2 ++ reverse (sort cards)
              (_, []) -> deck1 ++ reverse (sort cards)
              ((down1 : rest1), (down2 : rest2)) ->
                playGame rest1 rest2 (cards ++ [down1, down2]))))


