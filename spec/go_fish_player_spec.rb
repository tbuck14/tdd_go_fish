require_relative '../lib/go_fish_player'
require_relative '../lib/playing_card'

describe 'GoFishPlayer' do

    context '#play_card' do 
        it 'returns the top card of a players hand' do 
            player = GoFishPlayer.new('hobart',[PlayingCard.new('2','spades'),PlayingCard.new('10','hearts'),PlayingCard.new('A','clubs')])
            expect(player.play_card.rank).to(eq('A'))
            expect(player.play_card.suit).to(eq('hearts'))
        end
    end

    context '#take_cards' do 
        it 'takes won cards and puts them on the bottom of the hand' do 
            player = GoFishPlayer.new('cliff',[])
            expect(player.cards_left).to(eq(0))
            player.take_cards([PlayingCard.new('2','spades'),PlayingCard.new('10','hearts')])
            expect(player.cards_left).to(eq(2))
            card = player.play_card
            expect(card.rank == '10' || card.rank == '2').to(eq(true))
        end
    end

    context '#check_hand_for' do
        it 'checks for cards of a rank and returns nil when player doesnt have any' do 
            player = GoFishPlayer.new('trevor',[PlayingCard.new('2','spades')])
            expect(player.check_hand_for('A')).to(eq(nil))
        end
        it 'checks for cards of a rank and returns a single card if the player has it, also removes it from players hand' do 
            player = GoFishPlayer.new('trevor',[PlayingCard.new('2','spades'),PlayingCard.new('3','diamonds')])
            returned_cards = player.check_hand_for('2')
            expect(returned_cards).not_to(eq(nil))
            expect(returned_cards.first.rank).to(eq('2'))
            expect(player.cards_left).to(eq(1))
        end
        it 'checks for cards of a rank and returns multiple cards if player has more than one card of that rank' do 
            player = GoFishPlayer.new('trevor',[PlayingCard.new('2','spades'),PlayingCard.new('A','hearts'),PlayingCard.new('A','clubs')])
            returned_cards = player.check_hand_for('A')
            expect(returned_cards.count).to(eq(2))
            expect(returned_cards.first.rank).to(eq('A'))
            expect(returned_cards.last.rank).to(eq('A'))
            expect(player.cards_left).to(eq(1))
        end
    end
end