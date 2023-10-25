#![allow(non_snake_case,non_camel_case_types,dead_code)]


/*
    Below is the function stub for deal. Add as many helper functions
    as you like, but the deal function should not be modified. Just
    fill it in.
    
    Test your code by running 'cargo test' from the war_rs directory.
*/


//This function deals the cards to both players of the game by calling the deal_deck function to hand out the cards
//The deck is dealt to both players, and then the game is ran and winner is the variable that stores the winning deck
//Then the deck is iterated through in order to remove ace weight using the remove ace function and stores it in winning_deck
fn deal(shuf: &[u8; 52]) -> [u8; 52]
{
    let mut deck = shuf
    .iter()
    .map(|&c| apply_ace(c))
    .rev()
    .collect::<Vec<u8>>();

    let (p1, p2) = deal_deck(&mut deck);

    let winner = play_war(&p1, &p2, &[]);

    let mut winning_deck = [0; 52];
    for (i, card) in winner.iter().enumerate() {
        winning_deck[i] = remove_ace(*card);
    }

    winning_deck.reverse();
    return winning_deck

}

//This function takes in the deck given and deals it to each player
fn deal_deck(deck: &mut Vec<u8>) -> ([u8; 26], [u8; 26]) {
    let mut p1 = [0; 26];
    let mut p2 = [0; 26];

    for (i, card) in deck.iter().enumerate() {
        if i % 2 == 0 {
            p1[i / 2] = *card;
        } else {
            p2[i / 2] = *card;
        }
    }
    (p1, p2)
}


//This function is the war game, players decks are brought in with tied_cards ready to store any tied cards from war.
fn play_war(player1_deck: &[u8], player2_deck: &[u8], tied_cards: &[u8]) -> Vec<u8> {
    //Use a match case to recurss through the cases aslong as one player or the other has cards in there deck
    match (player1_deck.is_empty(), player2_deck.is_empty()) {
        //The base cases then check the players decks to see if one players is empty, in turn making the other
        (true, false) => player2_deck.iter().chain(tied_cards.iter()).cloned().rev().collect(),
        (false, true) => player1_deck.iter().chain(tied_cards.iter()).cloned().rev().collect(),
        //This case indicates that infinite war has occurred and just returns the deck of cards sorted
        (true, true) => {
            let mut sorted_cards = tied_cards.to_vec();
            sorted_cards.sort_unstable();
            return sorted_cards
        }
        //This case occurs when none of the others are caught indicating that the normal game can occur. A card is taken from each players deck
        //and compared. The cards being played are stored in a temp variable and then sorted and reversed, and added to the winners deck.
        _ => { 
            let deck1_rem = &player1_deck[1..];
            let deck2_rem = &player2_deck[1..];
            
            if player1_deck[0] > player2_deck[0] {
                let mut cards = [player1_deck[0], player2_deck[0]].iter().copied().chain(tied_cards.iter().copied()).collect::<Vec<u8>>();
                cards.sort();
                cards.reverse();
                let mut newp1 = deck1_rem.to_vec();
                newp1.extend(cards);
                play_war(&newp1, deck2_rem, &[])
            } else {
                if player2_deck[0] > player1_deck[0] {
                    let mut cards = [player1_deck[0], player2_deck[0]].iter().copied().chain(tied_cards.iter().copied()).collect::<Vec<u8>>();
                    cards.sort();
                    cards.reverse();
                    let mut newp2 = deck2_rem.to_vec();
                    newp2.extend(cards);
                    play_war(deck1_rem, &newp2, &[])
                    //This case occurs when both decks aren't empty. (aka.) the cards are equal and war is occurring. Two face down cards are created from
                    //each players deck. The cards that were tied are then assigned to tied_cards. The face down cards are also added to tied_cards and the game
                    //function is called again with the players remaining decks and the tied cards.  
                } else {
                    if !deck1_rem.is_empty() && !deck2_rem.is_empty() {
                        let face_down1 = deck1_rem[0];
                        let face_down2 = deck2_rem[0];
                        let mut cards = [player1_deck[0], player2_deck[0]].iter().copied().chain(tied_cards.iter().copied()).collect::<Vec<u8>>();
                        cards.sort();
                        cards.reverse();
                        let mut tie_cards = cards.to_vec();
                        tie_cards.extend(&[face_down1, face_down2]);
                        play_war(&deck1_rem[1..], &deck2_rem[1..], &tie_cards)
                    } else {
                        let mut cards = [player1_deck[0], player2_deck[0]].iter().copied().chain(tied_cards.iter().copied()).collect::<Vec<u8>>();
                        cards.sort();
                        cards.reverse();
                        play_war(deck1_rem, deck2_rem, &cards)
                    }
                }
            }
        }
    }
}


//Helper function to apply ace weight to deck
fn apply_ace(card: u8) -> u8 {
    match card {
        1 => 14,
        _ => card,
    }
}


//Helper function to remove ace weight to deck
fn remove_ace(card: u8) -> u8 {
    match card {
        1 => 14,
        14 => 1,
        _ => card,
    }
}




#[cfg(test)]
#[path = "tests.rs"]
mod tests;