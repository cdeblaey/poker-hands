# ---------------------------------------------------------------------
# Problem Statement:
# The file, p054_poker.txt, contains one-thousand random hands dealt to
# two players. Each line of the file contains ten cards (separated by a
# single space): the first five are Player 1's cards and the last five
# are Player 2's cards. You can assume that all hands are valid (no
# invalid characters or repeated cards), each player's hand is in no
# specific order, and in each hand there is a clear winner.
#
# How many hands does Player 1 win?
#
# Assumptions: Five of a Kind is not possible (nothing is wild, and
#   there are no Jokers in the deck).
#
# Poker Hand Ranking, highest to lowest:
#  • Royal Flush
#  • Straight Flush
#  • Four of a Kind
#  • Full House
#  • Flush
#  • Straight
#  • Three of a kind
#  • Two Pair
#  • One Pair
#  • High Card
#
# Usage:
#   ruby play.rb
# ---------------------------------------------------------------------

require './lib/hand.rb'

if __FILE__ == $0
  count = 0
  File.open('data/p054_poker.txt').read.each_line do |line|
    line.strip!
    mid = line.length/2
    count += 1 if Hand.new(line[0...mid]) > Hand.new(line[mid..-1])
  end

  puts "Player 1 wins #{count} times."
end
