# War-Card-Game
The war Card game is implemented in three different languages Elixir, Haskell, and Rust.


In this simulated game of War, you begin with a shuffled deck of 52 cards, which has already been shuffled for you. The cards are distributed alternately to two players, resulting in each player having 26 cards. In each round, both players reveal the top card from their respective piles. The player with the higher-ranked card wins both cards, and these cards are placed at the bottom of their pile.
The card ranks follow the sequence from 2 to 10, then Jack, Queen, King, and Ace, with Aces considered the highest. If the two revealed cards are of the same rank, a "war" is initiated. During a war, each player places one card face down, followed by one card face up. The player with the higher face-up card claims both piles, which now consist of the original tied cards and the additional four cards from the war. If the face-up cards are tied again, the process repeats, and more cards may be added to the pile until a winner is determined.
The game continues until one of the players runs out of cards. When this happens, the player with no cards remaining is the loser, and the other player is declared the winner. If a player runs out of cards during a war, it also results in a loss for that player.

