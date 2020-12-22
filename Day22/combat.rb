require 'pry'

class Combat
  def initialize(decks)
    @deck1, @deck2 = unwrap(decks)
    @p1_deck = @deck1.clone
    @p2_deck = @deck2.clone
  end

  def play
    reset_game
    play_rounds
    print_score
  end

  def recursive_play
    reset_game
    play_rounds(true)
    print_score
  end

  private

  def play_rounds(recursive = false, deck1 = @p1_deck, deck2 = @p2_deck, states = {})
    until game_complete?(deck1, deck2)
      # track states for Part 2
      return 'p1' if states[deck1.join(',') + deck2.join(',')] == true

      states[deck1.join(',') + deck2.join(',')] = true

      # deal cards
      card1 = deck1.shift
      card2 = deck2.shift

      # Part 2 recursion
      if subdecks?([card1, card2], [deck1, deck2]) && recursive
        winner = play_rounds(true, deck1.slice(0..card1 - 1), deck2.slice(0..card2 - 1))
      else
        winner = combat(card1, card2)
      end
      winner == 'p1' ? deck1 += [card1, card2] : deck2 += [card2, card1]
    end
    @p1_deck = deck1
    @p2_deck = deck2
    deck2.empty? ? 'p1' : 'p2'
  end

  def combat(p1_card, p2_card)
    p1_card > p2_card ? 'p1' : 'p2'
  end

  def subdecks?(cards, decks)
    cards[0] <= decks[0].length && cards[1] <= decks[1].length
  end

  def game_complete?(p1_deck, p2_deck)
    p1_deck.empty? || p2_deck.empty?
  end

  def tally(deck)
    deck.map.with_index { |card, ind| card * (deck.length - ind) }.reduce(&:+)
  end

  def print_score
    @p1_deck.empty? ? (p "player2 wins, score: #{tally(@p2_deck)}") : (p "player1 wins, score: #{tally(@p1_deck)}")
  end

  def unwrap(decks)
    decks.map { |deck| deck.split("\n").slice(1..-1).map(&:to_i) }
  end

  def reset_game
    @p1_deck = @deck1.clone
    @p2_deck = @deck2.clone
  end
end
