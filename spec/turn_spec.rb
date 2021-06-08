require_relative '../lib/turn'
require_relative '../lib/go_fish_player'
require_relative '../lib/go_fish_game'
require_relative '../lib/playing_card'
describe "Turn" do 
    
    context '#start_turn' do 
        it 'checks the hand of they player asked and awards cards if they have them' do 
            player1 = GoFishPlayer.new('player1')
            player2 = GoFishPlayer.new('player2',[PlayingCard.new('2','spades')])
            game = GoFishGame.new([player1,player2])
            turn = Turn.new(player1,'2',player2,game.deck)
            turn.start_turn
            expect(player1.cards_left).to(eq(1))
            expect(player2.cards_left).to(eq(0))
        end
        it 'checks the hand of they player asked and if they dont have them draw a card from the deck' do 
            player1 = GoFishPlayer.new('player1')
            player2 = GoFishPlayer.new('player2')
            game = GoFishGame.new([player1,player2])
            turn = Turn.new(player1,'2',player2,game.deck)
            turn.start_turn
            expect(player1.cards_left).to(eq(1))
            expect(player2.cards_left).to(eq(0))
        end
    end

end