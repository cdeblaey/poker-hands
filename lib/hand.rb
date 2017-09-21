class Hand
  include Comparable

  def initialize(hand)
    @hand = hand
  end

  # Royal Flush - a hand containing an ace-high straight flush
  def royal_flush?
    straight_flush? && @hand.include?('A')
  end

  # Straight Flush - a hand containing five cards of sequential rank, all of the same suit
  def straight_flush?
    flush? && straight?
  end

  # Four of a Kind - a hand containing four cards of the same rank
  def four_of_a_kind?
    n_of_a_kind? 4
  end

  # Full House - a hand containing three cards of one rank and two cards of another rank
  def full_house?
    n_and_m_of_a_kind? 3, 2
  end

  # Flush - a hand containing five cards all of the same suit, not all of sequential rank
  def flush?
    @hand =~ /((S.*){5}|(H.*){5}|(D.*){5}|(C.*){5})/ ? true : false
  end

  # Straight - a hand containing five cards of sequential rank, not all of the same suit
  def straight?
    hand = values.sort
    hand.uniq.length == 5 && hand[4] - hand[0] == 4
  end

  # Three of a Kind - a hand containing three cards of the same rank
  def three_of_a_kind?
    n_of_a_kind? 3
  end

  # Two Pair - a hand containing two cards of the same rank and two cards of another rank
  def two_pair?
    n_and_m_of_a_kind? 2, 2
  end

  # One Pair - a hand containing two cards of the same rank
  def one_pair?
    n_of_a_kind? 2
  end

  # Convert cards in a poker hand to their numerical values
  def values
    hand = @hand.dup

    # Strip away cards' suits
    hand = hand.gsub(/(S|H|D|C)/, '')

    # Replace ace through ten cards with their numerical values
    hand = hand.gsub(/[AKQJT]/, 'A'=>'14', 'K'=>'13', 'Q'=>'12', 'J'=>'11', 'T'=>'10')

    # Return an array of integer values
    hand.split.map(&:to_i)
  end

  private

  # determine if a hand has N cards of the same rank
  def n_of_a_kind? n
    values.each { |card| return true if values.count(card) >= n }
    false
  end

  # determine if a hand has multiple groups (N, M) of cards of the same rank
  def n_and_m_of_a_kind? n, m
    hand = values
    values.each do |card|
      if hand.count(card) >= n
        hand.delete(card)
        hand.each { |card2| return true if hand.count(card2) >= m }
      end
    end
    false
  end

  # compare this hand to another and determine the one with the high card
  def tie_breaker_single hand2
    values.sort.reverse <=> hand2.values.sort.reverse
  end

  # compare this hand to another and determine the high card from the remaining cards after rank groups are removed
  def tie_breaker_multi hand2
    values1 = values.sort.reverse
    values2 = hand2.values.sort.reverse
    4.downto(1).each do |num|
      pick1 = values1.select {|card| values1.count(card) == num}
      pick2 = values2.select {|card| values2.count(card) == num}
      return pick1 <=> pick2 if pick1 != pick2
    end
    0 # hands are identical
  end

  # compare this hand to another hand and go to a tie-breaker if both are of the same rank
  def <=> hand2
    ranks = ['royal_flush?', 'straight_flush?', 'four_of_a_kind?', 'full_house?', 'flush?', 'straight?', 'three_of_a_kind?', 'two_pair?', 'one_pair?']
    ranks.each do |rank|
      if send(rank)
        if hand2.send(rank)
          return tie_breaker_single hand2 if rank.include?('flush') || rank.include?('straight')
          return tie_breaker_multi hand2
        end
        return 1
      end
      return -1 if hand2.send(rank)
    end
    tie_breaker_single hand2
  end
end
