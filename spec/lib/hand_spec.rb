require 'hand'

RSpec.describe Hand do
  let(:royal_flush)     {'AS KS QS JS TS'}
  let(:straight_flush)  {'KS QS JS TS 9S'}
  let(:four_of_a_kind)  {'TS TH 3C TD TC'}
  let(:full_house)      {'AH 9C 9D AD 9H'}
  let(:flush)           {'AS KS QS JS 6S'}
  let(:straight)        {'AH KD TD JD QD'}
  let(:three_of_a_kind) {'AS KH QD KC KS'}
  let(:two_pair)        {'QD JC QS JH 2D'}
  let(:one_pair)        {'8S 2H KD 3C 8H'}

  describe 'poker hand utility methods' do
    context 'with valid input' do
      it 'assigns numerical values to each of the cards in a hand and strips out their suits' do
        expect(Hand.new('AS KS QS JS TS 9S 8S 7S 6S 5S 4S 3S 2S
                         AH KH QH JH TH 9H 8H 7H 6H 5H 4H 3H 2H
                         AD KD QD JD TD 9D 8D 7D 6D 5D 4D 3D 2D
                         AC KC QC JC TC 9C 8C 7C 6C 5C 4C 3C 2C').values)
          .to match_array([14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2,
                           14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2,
                           14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2,
                           14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2])
      end
    end

    context 'with one hand' do
      it 'determines if a hand has N cards of the same rank' do
        expect(Hand.new('AS KS QS JS AH').send(:n_of_a_kind?, 2)).to be_truthy
        expect(Hand.new('AS KS QS AD AC').send(:n_of_a_kind?, 3)).to be_truthy
        expect(Hand.new('AS KS AH AD AC').send(:n_of_a_kind?, 4)).to be_truthy
        expect(Hand.new('AS KS QS JS TH').send(:n_of_a_kind?, 2)).to be_falsey
      end

      it 'determines if a hand has multiple specified groups of cards of the same rank' do
        expect(Hand.new(two_pair)        .send(:n_and_m_of_a_kind?, 2, 2)).to be_truthy
        expect(Hand.new(full_house)      .send(:n_and_m_of_a_kind?, 3, 2)).to be_truthy
        expect(Hand.new('AS KS AD KH AH').send(:n_and_m_of_a_kind?, 3, 2)).to be_truthy
        expect(Hand.new(royal_flush)     .send(:n_and_m_of_a_kind?, 2, 2)).to be_falsey
        expect(Hand.new(straight_flush)  .send(:n_and_m_of_a_kind?, 2, 2)).to be_falsey
        expect(Hand.new(four_of_a_kind)  .send(:n_and_m_of_a_kind?, 2, 2)).to be_falsey
        expect(Hand.new(flush)           .send(:n_and_m_of_a_kind?, 2, 2)).to be_falsey
        expect(Hand.new(straight)        .send(:n_and_m_of_a_kind?, 2, 2)).to be_falsey
        expect(Hand.new(three_of_a_kind) .send(:n_and_m_of_a_kind?, 2, 2)).to be_falsey
        expect(Hand.new(one_pair)        .send(:n_and_m_of_a_kind?, 2, 2)).to be_falsey
      end
    end

    context 'with two hands' do
      it 'determines the hand with the high card' do
        expect(Hand.new(royal_flush)   .send(:tie_breaker_single, Hand.new(straight_flush))).to eq (1)
        expect(Hand.new(royal_flush)   .send(:tie_breaker_single, Hand.new(royal_flush)))   .to eq (0)
        expect(Hand.new(four_of_a_kind).send(:tie_breaker_single, Hand.new(royal_flush)))   .to eq (-1)
        expect(Hand.new(straight)      .send(:tie_breaker_single, Hand.new(straight_flush))).to eq (1)
        expect(Hand.new(straight)      .send(:tie_breaker_single, Hand.new(straight)))      .to eq (0)
        expect(Hand.new(four_of_a_kind).send(:tie_breaker_single, Hand.new(straight)))      .to eq (-1)
      end

      it 'determines the high card excluding cards that belong to matching groups' do
        expect(Hand.new(four_of_a_kind).send(:tie_breaker_multi, Hand.new('TS TH 2C TD TC'))).to eq (1)
        expect(Hand.new(four_of_a_kind).send(:tie_breaker_multi, Hand.new(four_of_a_kind)))  .to eq (0)
        expect(Hand.new(four_of_a_kind).send(:tie_breaker_multi, Hand.new('TS TH 4C TD TC'))).to eq (-1)
      end
    end
  end

  describe 'poker hand identification methods' do
    context 'with valid input' do
      it 'identifies One Pair in a hand containing two cards of the same rank' do
        expect(Hand.new('8S 2H KD 3C 8H').one_pair?).to be_truthy
        expect(Hand.new('8S 2H 8D 8C 7S').one_pair?).to be_truthy
        expect(Hand.new('8S 2H KD 3C 4S').one_pair?).to be_falsey
      end

      it 'identifies Two Pair in a hand containing two cards of the same rank and two cards of another rank' do
        expect(Hand.new('QD JC QS JH 2D').two_pair?).to be_truthy
        expect(Hand.new('QD QS JC JH JD').two_pair?).to be_truthy
        expect(Hand.new('QD JC TS JH 2D').two_pair?).to be_falsey
      end

      it 'identifies Three of a Kind in a hand containing three cards of the same rank' do
        expect(Hand.new('AS KH QD KC KS').three_of_a_kind?).to be_truthy
        expect(Hand.new('QD QS JC JH JD').three_of_a_kind?).to be_truthy
        expect(Hand.new('AS KH QD KC TS').three_of_a_kind?).to be_falsey
      end

      it 'identifies a Straight in a hand containing five cards of sequential rank regardless of suit' do
        expect(Hand.new('AH KD TD JD QD').straight?).to be_truthy
        expect(Hand.new('2D 5D 3D 4D 6H').straight?).to be_truthy
        expect(Hand.new('2H 2D 5D 3D 4D').straight?).to be_falsey
        expect(Hand.new('2D 3D 4D 5D 7D').straight?).to be_falsey
      end

      it 'identifies a Flush in a hand containing five cards all of the same suit regardless of sequential rank' do
        expect(Hand.new('AS KS QS JS 6S').flush?).to be_truthy
        expect(Hand.new('2C AC 3C JC 4C').flush?).to be_truthy
        expect(Hand.new('2C AC 3C JC 4D').flush?).to be_falsey
      end

      it 'identifies a Full House in a hand containing three cards of one rank and two cards of another rank' do
        expect(Hand.new('AH 9C 9D AD 9H').full_house?).to be_truthy
        expect(Hand.new('AH 2C 9D AD 9H').full_house?).to be_falsey
      end

      it 'identifies Four of a Kind in a hand containing four cards of the same rank' do
        expect(Hand.new('TS TH 2C TD TC').four_of_a_kind?).to be_truthy
        expect(Hand.new('TS TH 2C TD QC').four_of_a_kind?).to be_falsey
      end

      it 'identifies a Straight Flush in a hand containing five cards of sequential rank, all of the same suit' do
        expect(Hand.new('JS TS QS AS KS').straight_flush?).to be_truthy
        expect(Hand.new('8H 7H 9H JH TH').straight_flush?).to be_truthy
        expect(Hand.new('5D 4D 6D 8D 7D').straight_flush?).to be_truthy
        expect(Hand.new('3C 2C 4C 6C 5C').straight_flush?).to be_truthy
        expect(Hand.new('JS TC QS AS KS').straight_flush?).to be_falsey
        expect(Hand.new('3C 2C 4D 6C 5C').straight_flush?).to be_falsey
      end

      it 'identifies a Royal Flush in a hand containing an ace-high straight flush' do
        expect(Hand.new('AS KS QS JS TS').royal_flush?).to be_truthy
        expect(Hand.new('TH JH QH KH AH').royal_flush?).to be_truthy
        expect(Hand.new('KD QD AD TD JD').royal_flush?).to be_truthy
        expect(Hand.new('TC QC KC JC AC').royal_flush?).to be_truthy
        expect(Hand.new('AS KS QS JS TC').royal_flush?).to be_falsey
        expect(Hand.new('AS KS QS JS 9S').royal_flush?).to be_falsey
      end
    end
  end

  describe 'poker hand comparison methods' do
    context 'with two valid hands' do
      it 'determines the winning hand via direct comparison' do
        expect(Hand.new(royal_flush)).to be > Hand.new(straight_flush)
        expect(Hand.new(royal_flush)).to be > Hand.new(four_of_a_kind)
        expect(Hand.new(royal_flush)).to be > Hand.new(full_house)
        expect(Hand.new(royal_flush)).to be > Hand.new(flush)
        expect(Hand.new(royal_flush)).to be > Hand.new(straight)
        expect(Hand.new(royal_flush)).to be > Hand.new(three_of_a_kind)
        expect(Hand.new(royal_flush)).to be > Hand.new(two_pair)
        expect(Hand.new(royal_flush)).to be > Hand.new(one_pair)

        expect(Hand.new(straight_flush)).to be > Hand.new(four_of_a_kind)
        expect(Hand.new(straight_flush)).to be > Hand.new(full_house)
        expect(Hand.new(straight_flush)).to be > Hand.new(flush)
        expect(Hand.new(straight_flush)).to be > Hand.new(straight)
        expect(Hand.new(straight_flush)).to be > Hand.new(three_of_a_kind)
        expect(Hand.new(straight_flush)).to be > Hand.new(two_pair)
        expect(Hand.new(straight_flush)).to be > Hand.new(one_pair)

        expect(Hand.new(four_of_a_kind)).to be > Hand.new(full_house)
        expect(Hand.new(four_of_a_kind)).to be > Hand.new(flush)
        expect(Hand.new(four_of_a_kind)).to be > Hand.new(straight)
        expect(Hand.new(four_of_a_kind)).to be > Hand.new(three_of_a_kind)
        expect(Hand.new(four_of_a_kind)).to be > Hand.new(two_pair)
        expect(Hand.new(four_of_a_kind)).to be > Hand.new(one_pair)
        expect(Hand.new(four_of_a_kind)).to be > Hand.new('TS TH 2C TD TC') # Four of a Kind vs Four of a Kind (High Card)

        expect(Hand.new(full_house)).to be > Hand.new(flush)
        expect(Hand.new(full_house)).to be > Hand.new(straight)
        expect(Hand.new(full_house)).to be > Hand.new(three_of_a_kind)
        expect(Hand.new(full_house)).to be > Hand.new(two_pair)
        expect(Hand.new(full_house)).to be > Hand.new(one_pair)
        expect(Hand.new(full_house)).to be > Hand.new('TH 9C 9D TD 9H') # Full House vs Full House (High Card)

        expect(Hand.new(flush)).to be > Hand.new(straight)
        expect(Hand.new(flush)).to be > Hand.new(three_of_a_kind)
        expect(Hand.new(flush)).to be > Hand.new(two_pair)
        expect(Hand.new(flush)).to be > Hand.new(one_pair)
        expect(Hand.new(flush)).to be > Hand.new('TS 9S 8S 7S 5S') # Flush vs Flush (High Card)

        expect(Hand.new(straight)).to be > Hand.new(three_of_a_kind)
        expect(Hand.new(straight)).to be > Hand.new(two_pair)
        expect(Hand.new(straight)).to be > Hand.new(one_pair)
        expect(Hand.new(straight)).to be > Hand.new('KC QD JD TD 9D') # Straight vs Straight (High Card)

        expect(Hand.new(three_of_a_kind)).to be > Hand.new(two_pair)
        expect(Hand.new(three_of_a_kind)).to be > Hand.new(one_pair)
        expect(Hand.new(three_of_a_kind)).to be > Hand.new('2S KH 3D KC KS') # Three of a Kind vs Three of a Kind (High Card)

        expect(Hand.new(two_pair)).to be > Hand.new(one_pair)
        expect(Hand.new(two_pair)).to be > Hand.new('TD JC TS JH 2D') # Two Pair vs Two Pair (High Card)

        expect(Hand.new(one_pair)).to be > Hand.new('7S 2H KD 3C 7H') # One Pair vs One Pair
        expect(Hand.new(one_pair)).to be > Hand.new('8D 2H QD 3C 8C') # One Pair vs One Pair (High Card)

        expect(Hand.new('AS QH TD 8C 6S')).to be > Hand.new('KS JH 9D 7C 5S') # High Card
        expect(Hand.new('TS 8H 6D 4C 2S')).to be < Hand.new('JS 9H 7D 5C 3S') # High Card

        expect(Hand.new(straight_flush)).to be  < Hand.new(royal_flush)
        expect(Hand.new(four_of_a_kind)).to be  < Hand.new(royal_flush)
        expect(Hand.new(full_house)).to be      < Hand.new(royal_flush)
        expect(Hand.new(flush)).to be           < Hand.new(royal_flush)
        expect(Hand.new(straight)).to be        < Hand.new(royal_flush)
        expect(Hand.new(three_of_a_kind)).to be < Hand.new(royal_flush)
        expect(Hand.new(two_pair)).to be        < Hand.new(royal_flush)
        expect(Hand.new(one_pair)).to be        < Hand.new(royal_flush)

        # Don't need to test EQUAL since the spec says that in each hand there is a clear winner.
      end
    end
  end
end
