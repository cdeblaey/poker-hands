# Project Euler #54 Solution in Ruby

### Problem Statement:
The file, p054_poker.txt, contains one-thousand random hands dealt to two players. Each line of the file contains ten cards (separated by a single space): the first five are Player 1's cards and the last five are Player 2's cards. You can assume that all hands are valid (no invalid characters or repeated cards), each player's hand is in no specific order, and in each hand there is a clear winner.
How many hands does Player 1 win?

### Assumption:
* No card is 'wild' and there are no Jokers in the deck, therefore Five of a Kind is not possible.

### Usage:
* Run `bundle install` to download the `rspec` and `guard` dependencies.
* To run guard: `bundle exec guard`
* To run rspec on its own: `bundle exec rspec`
* To execute the program (from root dir): `bundle exec ruby play.rb`

---
https://projecteuler.net/problem=54